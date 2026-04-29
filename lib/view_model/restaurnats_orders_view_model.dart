
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:yosr_pos/components/loading_indicator.dart';
import 'package:yosr_pos/model/restaurant_order.dart';
import 'package:yosr_pos/model/store_order.dart';
import 'package:yosr_pos/services/api_crud_services.dart';
import 'package:yosr_pos/services/stomp_service.dart';
import 'package:yosr_pos/utilities/api_urls.dart';
import 'package:yosr_pos/utilities/colors.dart';
import 'package:yosr_pos/utilities/functions.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:yosr_pos/model/restaurant_order.dart';
import 'package:intl/intl.dart' as intl;

class RestaurantsOrdersViewModel extends APICrudServices{
  bool isLoading = false;
  List<RestaurantOrder> orders = [];
  bool isStoreOpen = false;
  int currentPage = 0;
  bool isLastPage = false;

  getOrders({bool refresh = true}) async {
    if (refresh) {
      currentPage = 0;
      isLastPage = false;
      orders = [];
    }

    if (isLastPage && !refresh) return;

    if (refresh) {
      isLoading = true;
    }
    update();

    final resId = await tokenManager.getUserId();
    final value = await get(
      endPoint: 'api/v1/checkout/restaurants/${resId}/orders',
      queryParams: {
        'page': currentPage.toString(),
        'size': '10',
      },
    );

    isLoading = false;
    if (value.status) {
      List<RestaurantOrder> newOrders = (value.data['content'] as List)
          .map((e) => RestaurantOrder.fromJson(e))
          .toList();
      orders.addAll(newOrders);
      isLastPage = value.data['last'] ?? true;
      if (!isLastPage) {
        currentPage++;
      }
    }
    update();
  }

  getRestaurantStatus() async {
    final resId = await tokenManager.getUserId();
    final response = await get(endPoint: 'api/v1/restaurants/$resId/restaurantOpen');
    if (response.status) {
      isStoreOpen = response.data == true;
      update();
    }
  }

  toggleStoreStatus(bool status) async {
    final resId = await tokenManager.getUserId();
    isStoreOpen = status;
    update();
    
    final response = await put(
      endPoint: 'api/v1/restaurants/$resId/storeOpen',
      body: {},
      queryParams: {'storeOpen': status.toString()},
    );

    if (!response.status) {
      isStoreOpen = !status;
      update();
    }
  }

  acceptOrder({required String orderId})async{
    showLoadingIndicator();
    await put(endPoint: 'api/v1/food_order/${orderId}/status', body: {},queryParams: {
      'orderId': orderId,
      'status': 'RESTAURANT_ACCEPTED',
    }).then((value) {
      print('api/v1/orders/${orderId}/status');
      print(orderId);
    print('accept');
      print(value.data);
      dismissLoadingIndicator();
      if(value.status){
        getOrders();
        showSnackBar(message: 'تم قبول الطلب بنجاح', isError:  false);
      }else{
        showSnackBar(message: 'فشل قبول الطلب ، حاول في وقت لاحق', isError:  true);

      }
    },);
  }

  rejectOrder({required String orderId})async{
    showLoadingIndicator();
    await put(endPoint: 'api/v1/food_order/${orderId}/status', body: {},queryParams: {
      'orderId': orderId,
      'status': 'RESTAURANT_REJECTED',
    }).then((value) {
      dismissLoadingIndicator();
      if(value.status){
        getOrders();
        showSnackBar(message: 'تم رفض الطلب بنجاح', isError:  false);
      }else{
        showSnackBar(message: 'فشل رفض الطلب ، حاول في وقت لاحق', isError:  true);

      }
    },);
  }

  Future<Uint8List> loadAndResizeLogo() async {
    final data = await rootBundle.load('assets/logos/logo.png');
    final bytes = data.buffer.asUint8List();

    final originalImage = img.decodeImage(bytes)!;
    for (var pixel in originalImage) {
      if (pixel.a != 0) {
        pixel.r = mainColor.red;
        pixel.g = mainColor.green;
        pixel.b = mainColor.blue;
      }
    }
    final resized = img.copyResize(
      originalImage,
      width: 200, 
    );

    return Uint8List.fromList(img.encodePng(resized));
  }

  printOrder({required RestaurantOrder order})async{
    try {
      // تأكد إن الطابعة جاهزة
      await SunmiPrinter.bindingPrinter();

      await SunmiPrinter.initPrinter();

      await SunmiPrinter.startTransactionPrint(true);

      // طباعة اللوجو
      try {
        final logoBytes = await loadAndResizeLogo();
        await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
        await SunmiPrinter.printImage(logoBytes);
        await SunmiPrinter.lineWrap(1);
      } catch (e) {
        print('خطأ في تحميل/طباعة اللوجو: $e');
      }

      // العنوان
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(order.restaurantName);

      if (order.restaurantPhone.isNotEmpty) {
        await SunmiPrinter.printText('📞 ${order.restaurantPhone}');
      }

      await SunmiPrinter.printText(order.restaurantAddress);
      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.printText('------------------------------');

      // رقم الطلب
      await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
      await SunmiPrinter.printText('رقم الطلب: ${order.orderNum}');
      await SunmiPrinter.printText('العميل: ${order.customerName}');
      await SunmiPrinter.printText('الهاتف: ${order.customerPhone}');
      await SunmiPrinter.printText('العنوان: ${order.customerAddress}');
      await SunmiPrinter.printText('المدينة: ${order.customerCity}');
      await SunmiPrinter.printText('طريقة الدفع: ${order.paymentMethod == 'CASH' ? 'كاش' : order.paymentMethod == 'WALLET'?'محفظة':''}');
      await SunmiPrinter.printText('الحالة: ${formatStatus(order.status)}');
      await SunmiPrinter.lineWrap(1);

      await SunmiPrinter.printText('------------------------------');
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText('🧆 تفاصيل الطلب');
      await SunmiPrinter.printText('------------------------------');

      // العناصر
      await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
      for (final item in order.items) {
        await SunmiPrinter.printText(
            '${item.itemName}  x${item.quantity}   = ${item.lineTotal.toStringAsFixed(0)} د.ع');
      }

      await SunmiPrinter.printText('------------------------------');
      await SunmiPrinter.setAlignment(SunmiPrintAlign.RIGHT);
      await SunmiPrinter.printText('المجموع الفرعي: ${order.subtotal.toStringAsFixed(0)} د.ع');
      await SunmiPrinter.printText('تكلفة التوصيل: ${order.deliveryFee.toStringAsFixed(0)} د.ع');
      await SunmiPrinter.printText('تكلفة خدمة التطبيق: ${order.adminCommission!.toStringAsFixed(0)} د.ع');
      await SunmiPrinter.printText('الإجمالي: ${order.total.toStringAsFixed(0)} د.ع');

      await SunmiPrinter.printText('------------------------------');
      await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);

      if (order.notes.isNotEmpty) {
        await SunmiPrinter.printText('ملاحظات: ${order.notes}');
        await SunmiPrinter.lineWrap(1);
      }

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText('شكراً لتعاملكم ❤️');
      await SunmiPrinter.printText(
          'الوقت: ${intl.DateFormat("yyyy/MM/dd HH:mm").format(order.createdAt ?? DateTime.now())}');

      await SunmiPrinter.lineWrap(7);

      await SunmiPrinter.exitTransactionPrint(true);
    } catch (e) {
      print('🛑 خطأ أثناء الطباعة: $e');
    }


  }

  StompService stompService = StompService();

  initSocket() async {
    final restaurantId = await tokenManager.getUserId();
    stompService.connect(serverUrl: ServerUrls.socketBaseUrl, destination: '/topic/order/restaurant/$restaurantId', onMessage: (frame) {
      FlutterRingtonePlayer().play(
        android: AndroidSounds.notification,
        ios: IosSounds.glass,
        looping: false,
        volume: 1.0,
        asAlarm: false,
      );
      getOrders();
      showSnackBar(message: 'لديك طلب جديد', isError: false);

      //orders.add(OrderModel.fromJson(jsonDecode(frame.body!)['order']));
      update();
    },);
  }

  disposeSocket() {
    stompService.disconnect();
  }

  Future<void> saveFirebaseToken() async {
    try {
      final id = await tokenManager.getUserId();

      final fcmToken = await FirebaseMessaging.instance.getToken();

      print('FCM Token: $fcmToken');

      if (fcmToken == null) return;

      await post(
        endPoint: 'api/v1/notification/user/$id/device/$fcmToken',
        body: {},
      ).then((value) {
        print('success sending the id');
        print(value.data);
      });
    } catch (e) {
      print('❌ Failed to save FCM token: $e');
    }
  }


}