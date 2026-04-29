import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yosr_pos/view/merchant_orders/widgets/merchant_product_item_card.dart';
import 'package:yosr_pos/view_model/merchant_categories_products_view_model.dart';
import '../../utilities/colors.dart';
import '../../components/loading_indicator.dart';

class MerchantsCategoriesProductsView extends StatefulWidget {
  const MerchantsCategoriesProductsView({super.key});

  @override
  State<MerchantsCategoriesProductsView> createState() => _MerchantsCategoriesProductsViewState();
}

class _MerchantsCategoriesProductsViewState extends State<MerchantsCategoriesProductsView> {
  final controller = Get.put(MerchantCategoriesProductsViewModel());
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _productScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.getCategories();
    _categoryScrollController.addListener(_onCategoryScroll);
    _productScrollController.addListener(_onProductScroll);
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    _productScrollController.dispose();
    super.dispose();
  }

  void _onCategoryScroll() {
    if (_categoryScrollController.position.pixels >= _categoryScrollController.position.maxScrollExtent - 200) {
      if (!controller.isLoading && !controller.isLastPage) {
        controller.getCategories(refresh: false);
      }
    }
  }

  void _onProductScroll() {
    if (_productScrollController.position.pixels >= _productScrollController.position.maxScrollExtent - 200) {
      if (!controller.isProductsLoading && !controller.isProductsLastPage) {
        controller.getProducts(refresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text('الفئات والمنتجات', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: white,
        surfaceTintColor: white,
        elevation: 0,
      ),
      body: GetBuilder<MerchantCategoriesProductsViewModel>(
        builder: (controller) {
          if (controller.isLoading && controller.categories.isEmpty) {
            return const Center(child: LoadingIndicator());
          }

          return Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: ListView.builder(
                  controller: _categoryScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: controller.categories.length + (controller.isLastPage ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == controller.categories.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }
                    final category = controller.categories[index];
                    final isSelected = controller.selectedCategoryId == category.id;

                    return GestureDetector(
                      onTap: () => controller.selectCategory(category.id!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected ? mainColor : color5F5,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? mainColor : colorEEE,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: mainColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ] : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          category.name ?? '',
                          style: TextStyle(
                            color: isSelected ? white : black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              const Divider(height: 1, color: colorEEE),
              Expanded(
                child: controller.isProductsLoading && controller.products.isEmpty
                    ? const Center(child: LoadingIndicator())
                    : controller.products.isEmpty
                        ? const Center(
                            child: Text(
                              'لا توجد منتجات في هذه الفئة',
                              style: TextStyle(color: colorC9C, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            controller: _productScrollController,
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
                            itemCount: controller.products.length + (controller.isProductsLastPage ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index == controller.products.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return MerchantProductItemCard(
                                product: controller.products[index],
                                onToggleVisibility: (hide) {
                                  controller.toggleProductVisibility(controller.products[index], hide);
                                },
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
