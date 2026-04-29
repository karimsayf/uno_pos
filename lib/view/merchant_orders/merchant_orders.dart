import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yosr_pos/components/loading_indicator.dart';
import 'package:yosr_pos/view/auth/login.dart';
import 'package:yosr_pos/view/merchant_orders/merchants_categories_products_view.dart';
import 'package:yosr_pos/view_model/merchants_orders_view_model.dart';
import 'package:yosr_pos/view_model/restaurnats_orders_view_model.dart';
import '../../utilities/colors.dart';
import 'widgets/merchant_order_card.dart';


class MerchantOrders extends StatefulWidget {
  const MerchantOrders({super.key});

  @override
  State<MerchantOrders> createState() => _MerchantOrdersState();
}

class _MerchantOrdersState extends State<MerchantOrders> {
  final controller = Get.put(MerchantsOrdersViewModel());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    controller.getStoreStatus();
    controller.getOrders();
    controller.initSocket();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        controller.getOrders(refresh: false);
      }
    });

    controller.saveFirebaseToken();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        surfaceTintColor: white,
        backgroundColor: white,
        toolbarHeight: 75,
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: GetBuilder<MerchantsOrdersViewModel>(
          builder: (controller) => Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.menu, size: 28),
              ),
              const SizedBox(
                width: 10,
              ),
              Text('طلبات المتاجر',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),

              const Spacer(),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.isStoreOpen ? 'مفتوح' : 'مغلق',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: controller.isStoreOpen ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Transform.scale(
                    scale: 1,
                    child: CupertinoSwitch(
                      value: controller.isStoreOpen,
                      activeColor: Colors.green,
                      onChanged: (value) => controller.toggleStoreStatus(value),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logos/logo.webp', height: 60, errorBuilder: (context, error, stackTrace) => Icon(Icons.restaurant, size: 50, color: mainColor)),
                    const SizedBox(height: 10),
                    const Text(
                      'اونو POS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.category_outlined, color: mainColor),
              title: const Text(
                'الفئات والمنتجات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Get.back();
                Get.to(() => const MerchantsCategoriesProductsView());
              },
            ),
            const Divider(),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),
              ),
              onTap: () {
                controller.disposeSocket();
                controller.tokenManager.logout();
                Get.offAll(() => const Login());
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: GetBuilder<MerchantsOrdersViewModel>(
        builder: (controller) => controller.isLoading ? Center(child: LoadingIndicator()): RefreshIndicator(
          onRefresh: () {
            controller.getOrders();
            return Future.value(true);
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),

                if(controller.orders.isEmpty)...[
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/no_orders.webp',height: 200,),
                        SizedBox(height: 20,),
                        Text('لا توجد طلبات حتى الان',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)
                      ],
                    ),
                  )
                ],
                ...controller.orders.map((order) => MerchantOrderCard(orderModel: order,)),
                if (!controller.isLastPage)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
