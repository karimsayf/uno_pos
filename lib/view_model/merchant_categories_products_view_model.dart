import 'package:yosr_pos/model/category_model.dart';
import 'package:yosr_pos/model/restaurant_product_model.dart';
import 'package:yosr_pos/services/api_crud_services.dart';

class MerchantCategoriesProductsViewModel extends APICrudServices {
  bool isLoading = false;
  List<CategoryModel> categories = [];
  String? selectedCategoryId;
  int currentPage = 0;
  bool isLastPage = false;

  bool isProductsLoading = false;
  List<RestaurantProductModel> products = [];
  int currentProductsPage = 0;
  bool isProductsLastPage = false;

  Future<void> getCategories({bool refresh = true}) async {
    if (refresh) {
      currentPage = 0;
      isLastPage = false;
      categories = [];
    }

    if (isLastPage) return;

    isLoading = true;
    update();

    final id = await tokenManager.getUserId();
    final response = await get(
      endPoint: 'api/v1/categories/merchant/${id}',
      queryParams: {
        'page': currentPage.toString(),
        'size': '20',
      },
    );

    if (response.status) {
      List<CategoryModel> newCategories = [];
      if (response.data is List) {
        newCategories = (response.data as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
        isLastPage = true;
      } else if (response.data is Map && response.data['content'] is List) {
        newCategories = (response.data['content'] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
        isLastPage = response.data['last'] ?? true;
      }

      categories.addAll(newCategories);

      if (categories.isNotEmpty && selectedCategoryId == null) {
        selectCategory(categories[0].id!);
      }

      if (!isLastPage) {
        currentPage++;
      }
    }

    isLoading = false;
    update();
  }

  void selectCategory(String id) {
    selectedCategoryId = id;
    getProducts(refresh: true);
    update();
  }

  Future<void> getProducts({bool refresh = true}) async {
    if (selectedCategoryId == null) return;

    if (refresh) {
      currentProductsPage = 0;
      isProductsLastPage = false;
      products = [];
    }

    if (isProductsLastPage) return;

    isProductsLoading = true;
    update();

    final response = await get(
      endPoint: 'api/v1/items_shop/category/${selectedCategoryId}',
      queryParams: {
        'page': currentProductsPage.toString(),
        'size': '20',
      },
    );

    if (response.status) {
      List<RestaurantProductModel> newProducts = [];
      if (response.data is List) {
        newProducts = (response.data as List)
            .map((e) => RestaurantProductModel.fromJson(e))
            .toList();
        isProductsLastPage = true;
      } else if (response.data is Map && response.data['content'] is List) {
        newProducts = (response.data['content'] as List)
            .map((e) => RestaurantProductModel.fromJson(e))
            .toList();
        isProductsLastPage = response.data['last'] ?? true;
      }

      products.addAll(newProducts);

      if (!isProductsLastPage) {
        currentProductsPage++;
      }
    }

    isProductsLoading = false;
    update();
  }

  Future<void> toggleProductVisibility(RestaurantProductModel product, bool hide) async {
    product.hide = hide;
    update();

    final response = await put(
      endPoint: 'api/v1/items_shop/${product.id}/hide',
      body: {},
      queryParams: {'hide': hide.toString()},
    );

    print(response.data);
    if (!response.status) {
      product.hide = !hide;
      update();
    }
  }
}
