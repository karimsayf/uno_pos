import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

showSnackBar({required String message, required bool isError, String? title}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    textColor: Colors.white,
    fontSize: 16,
    backgroundColor: isError ? Colors.red.shade700 : Colors.green,
  );
 /* Get.snackbar(
    isDismissible: false,
    isError ? title ?? 'فشلت العملية' : "نجحت العملية",
    message,
    backgroundColor: isError ? Colors.red : Colors.green,
    colorText: Colors.white,
    messageText: Text(
      message,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Colors.white,
      ),
    ),
  );*/
}


formatStatus(String status){
  if(status == 'PENDING'){
    return 'طلب قيد الانتظار';
  }else if(status == 'ACCEPTED'){
    return "السائق في طريقه للتاجر";
  }else if(status == 'DELIVERING'){
    return 'يتم توصيل الطلب للعميل';
  }else if(status == 'DELIVERED'){
    return 'تم توصيل الطلب' ;
  }else if(status == 'COMPLETED'){
    return 'تم إكمال الطلب';
  }else if(status == 'RETURNING'){
    return 'يتم إرجاع الطلب';
  }else if(status == 'RETURNED'){
    return 'تم إرجاع الطلب';
  }else if(status == 'CANCELED'){
    return 'تم إلغاء الطلب';
  }else if(status == 'DELETED'){
    return 'تم حذف الطلب';
  }else if(status == 'RESTAURANT_ACCEPTED'){
    return "تم قبول الطلب من التاجر";
  }else if(status == 'RESTAURANT_REJECTED'){
    return "تم رفض الطلب من التاجر";
  }else{
    return status;
  }
}