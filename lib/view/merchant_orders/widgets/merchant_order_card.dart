import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yosr_pos/components/custom_title.dart';
import 'package:yosr_pos/model/cart_meal_model.dart';
import 'package:yosr_pos/model/restaurant_order.dart';
import 'package:yosr_pos/model/store_order.dart';
import 'package:yosr_pos/utilities/api_urls.dart';
import 'package:yosr_pos/utilities/colors.dart';
import 'package:yosr_pos/utilities/constants.dart';
import 'package:yosr_pos/utilities/functions.dart';
import 'package:yosr_pos/view_model/merchants_orders_view_model.dart';
import 'package:yosr_pos/view_model/restaurnats_orders_view_model.dart';


class MerchantOrderCard extends StatefulWidget {
  final StoreOrder orderModel;
  const MerchantOrderCard({super.key,required this.orderModel,});

  @override
  State<MerchantOrderCard> createState() => _MerchantOrderCardState();
}

class _MerchantOrderCardState extends State<MerchantOrderCard> {
  final MerchantsOrdersViewModel ordersViewModel = Get.find<MerchantsOrdersViewModel>();
  bool showItems = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: white,
      margin: EdgeInsets.only(bottom: 40),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                 "${DateFormat('EEEE، d MMMM y h:mm a', 'ar').format(DateTime.parse(widget.orderModel.createdDate!))}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color383,
                ),
              ),


            ],
          ),

          SizedBox(height: 20,),
          Container(

            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 2),
            decoration: BoxDecoration(
              color: color741.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child:  Center(
              child: CustomTitle(
                text: "${formatStatus(widget.orderModel.status!)}",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color741,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  ServerUrls.filesBaseUrl +(widget.orderModel.merchantPhoto??''),
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => SizedBox(
                    height: 80,
                    width: 80,
                    child: Center(
                      child: Icon(Icons.error_outline),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTitle(
                          text: "${widget.orderModel.merchantName}",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: black,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showItems = !showItems;
                            });
                          },
                          child: Row(
                            children: [
                              CustomTitle(
                                text: "${widget.orderModel.items!.length} منتجات",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: colorCAC,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                showItems? "assets/icons/arrow-up.webp" : "assets/icons/arrow_down.webp",
                                width: 25,
                                height: 25,
                                color: colorCAC,

                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTitle(
                      text: "رقم الطلب: ${widget.orderModel.orderNumber}",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colorCAC,
                    ),
                  ],
                ),
              )
            ],
          ),
          if(showItems)
            ...widget.orderModel.items!.map((item) => orderChoice(item)).toList(),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            height: 1,
            width: double.infinity,
            color: colorEEE,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTitle(
                      text: "${widget.orderModel.total} ${Constants.appCurrency}",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: black,
                    ),
                    SizedBox(height: 5,),
                    CustomTitle(
                      text: "مجموع الطلب",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: color383,
                    ),
                  ],
                ),
              ),
              /*const SizedBox(
                width: 5,
              ),
              Container(
                width: getSize(context).width * 0.35,
                height: 50,
                decoration: BoxDecoration(
                  color: color4B7,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomTitle(
                      text: "الطلب مجدداً",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      "assets/icons/arrow-left_android.webp",
                      scale: 2.5,
                      color: white,
                      package: 'restaurants',
                    ),
                  ],
                ),
              ),*/
            ],
          ),

          if(widget.orderModel.note != null && widget.orderModel.note! .isNotEmpty)...[
            SizedBox(height: 20,),
            Divider(color: Colors.black26,),
            SizedBox(height: 20,),
            Row(
              children: [
                Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ملاحظات العميل',style: TextStyle(color: Colors.grey),),
                    SizedBox(height: 10,),
                    Text(widget.orderModel.note!.isNotEmpty? widget.orderModel.note! : 'لا توجد ملاحظات'),
                  ],
                ),
              ],
            ),
          ],


          SizedBox(height: 20,),
          if(widget.orderModel.status == 'PENDING')
          Row(
            children: [
              Expanded(child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(mainColor),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ))
                  ),
                  onPressed: (){
                    ordersViewModel.acceptOrder(orderId: widget.orderModel.id!);
                  }, child: Text('قبول الطلب',style: TextStyle(color: Colors.white),))),
              SizedBox(width: 10,),
              Expanded(child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red.shade700),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ))
                  ),
                  onPressed: (){
                    ordersViewModel.rejectOrder(orderId: widget.orderModel.id!);

                  }, child: Text('رفض الطلب',style: TextStyle(color: Colors.white),)))
            ],
          )
          else
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(mainColor),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ))
                      ),
                      onPressed: (){
                        ordersViewModel.printOrder(order: widget.orderModel);
                      }, child: Text('طباعة الفاتورة',style: TextStyle(color: Colors.white),)),
                ),
              ],
            ),
          SizedBox(height: 20,),
          Divider(color: Colors.black26,),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  orderChoice(StoreOrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 5,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.network(
              ServerUrls.filesBaseUrl +item.item!.photo!,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => SizedBox(
                height: 50,
                width: 50,
                child: Center(child: Icon(Icons.error_outline),),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTitle(
                      text: "${item.item!.name}",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: black,
                    ),
                    CustomTitle(
                      text: "${item.item!.finalPrice} ${Constants.appCurrency}",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorCAC,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                CustomTitle(
                  text: "(${item.item!.quantity})",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorCAC,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
