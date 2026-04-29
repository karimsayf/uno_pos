import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:yosr_pos/components/loading_indicator.dart';
import 'package:yosr_pos/services/api_crud_services.dart';
import 'package:yosr_pos/utilities/functions.dart';
import 'package:yosr_pos/view/merchant_orders/merchant_orders.dart';
import 'package:yosr_pos/view/restaurnat_orders/restaurant_orders.dart';

class AuthViewModel extends APICrudServices{
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController usernameController =TextEditingController();
  final TextEditingController passwordController  =TextEditingController();
  bool obscurePassword = true;

  login()async{
      if(loginFormKey.currentState!.validate()){
        showLoadingIndicator();
        await post(endPoint: 'api/v1/register/login',queryParams: {

        } ,body: {
          'userName': usernameController.text.trim(),
          'password': passwordController.text
        }).then((value)async {
          print('result');
          print(value.data);
          dismissLoadingIndicator();
          if(value.status){
            await tokenManager.setToken(token: value.data['token']??'');
            await tokenManager.setUserId(id: value.data['id']??'');
            await tokenManager.setUserRole(userRole: value.data['roles']?[0]??'');
            await tokenManager.setUserFullName(name: value.data['fullName']??'');
            await tokenManager.setUserPhone(phoneNo: value.data['phone']??'');

            if(value.data['roles'][0] == 'MERCHANT'){
              Get.offAll(()=>MerchantOrders());
            }else if(value.data['roles'][0] == 'RESTAURANT'){
              Get.offAll(()=>RestaurantOrders());
            }
          }else{
            showSnackBar(message: value.data['message']??'حدثت مشكلة ، حاول في وقت لاحق', isError: true);
          }
        },);
      }else{
        return;
      }
  }
}