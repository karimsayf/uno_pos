import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:yosr_pos/model/api_response.dart';
import 'package:yosr_pos/utilities/api_urls.dart';
import 'package:yosr_pos/utilities/functions.dart';
import 'package:yosr_pos/view/auth/login.dart';
import 'token_manager.dart';

class APICrudServices extends GetxController{
  final TokenManager tokenManager = Get.find<TokenManager>();


  Future<APIResponse> get({required String endPoint,Map<String,dynamic>? queryParams,bool sendToken = true}) async {
    final token = await tokenManager.getToken();
    var response = await GetConnect(
      timeout: Duration(minutes: 2),).get(ServerUrls.baseUrl + endPoint,query: queryParams,
        headers: sendToken ?  {
          "Authorization" :"Bearer $token"
    }:{});


    log(response.body.toString());
    if(sendToken){
      checkTokenValidity(response);
    }

    if (response.status.hasError) {
      return APIResponse(status: false, data: response.body);
    } else {
      return APIResponse(status: true, data: response.body);
    }
  }

  Future<APIResponse> post({required String endPoint,required dynamic body,Map<String,dynamic>? queryParams,bool sendToken = true}) async {
    final token = await tokenManager.getToken();

    Response response = await GetConnect(
      timeout: Duration(minutes: 2),).post(ServerUrls.baseUrl + endPoint,jsonEncode(body),query: queryParams,
        headers: sendToken ? {
          "Authorization" :"Bearer $token",
        }: {     }).catchError((error) {
        //  return showSnackBar(message: 'Error Occurred, Please try again.', isError: true);
        });

    print(jsonEncode(body));
    print(response.body);
    log(response.body.toString());

    if(sendToken){
      checkTokenValidity(response);
    }

    if (response.status.hasError) {
      return APIResponse(status: false, data: response.body);
    } else {
      return APIResponse(status: true, data: response.body);
    }
  }

  Future<APIResponse> put({required String endPoint,required Map body,Map<String,dynamic>? queryParams}) async {
    final token = await tokenManager.getToken();

    var response = await GetConnect(
      timeout: Duration(minutes: 2),).put(ServerUrls.baseUrl + endPoint,body,query: queryParams,headers:  {
      "Authorization" :"Bearer $token"
    });

    checkTokenValidity(response);

    if (response.status.hasError) {
      return APIResponse(status: false, data: response.body);
    } else {
      return APIResponse(status: true, data: response.body);
    }
  }

  Future patch({required String endPoint,required Map body,Map<String,dynamic>? queryParams}) async {
    final token = await tokenManager.getToken();

    var response = await GetConnect(
      timeout: Duration(minutes: 2),).patch(ServerUrls.baseUrl + endPoint,body,query: queryParams,headers:  {
      "Authorization" :"Bearer $token"
    });

    checkTokenValidity(response);

    if (response.status.hasError) {
      return APIResponse(status: false, data: response.body);
    } else {
      return APIResponse(status: true, data: response.body);
    }
  }


  Future<APIResponse> delete({required String endPoint,Map<String,dynamic>? queryParams}) async {
    final token = await tokenManager.getToken();

    var response = await GetConnect(
      timeout: Duration(minutes: 2),).delete(ServerUrls.baseUrl + endPoint,query: queryParams,headers:  {
      "Authorization" :"Bearer $token",
    });
    checkTokenValidity(response);

    if (response.status.hasError) {
      return APIResponse(status: false, data: response.body);
    } else {
      return APIResponse(status: true, data: response.body);
    }
  }

  Future<APIResponse> uploadFile(String filePath) async {
    final token = await tokenManager.getToken();

    final uri = Uri.parse('${ServerUrls.baseUrl}/v1/media/other');

    // Create a multipart request
    final request = http.MultipartRequest('POST', uri)
    ..headers.addAll({
      "Authorization" :"Bearer $token"
    })
      ..files.add(await http.MultipartFile.fromPath('file', filePath));
    try {
      // Send the request
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      print(responseBody.body);
      // Check the response status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        return APIResponse(status: true, data: jsonDecode(responseBody.body)['data']);
      } else {
        return APIResponse(status: false, data: null);
      }
    } catch (e) {
      return APIResponse(status: false, data: null);
    }
  }

  Future<APIResponse> uploadVoice(String filePath) async {
    final token = await tokenManager.getToken();

    final uri = Uri.parse('${ServerUrls.baseUrl}/v1/media/voice');

    // Create a multipart request
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        "Authorization" :"Bearer $token"
      })
      ..files.add(await http.MultipartFile.fromPath('file', filePath));
    try {
      // Send the request
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        return APIResponse(status: true, data: jsonDecode(responseBody.body)['data']);
      } else {
        return APIResponse(status: false, data: null);
      }
    } catch (e) {
      return APIResponse(status: false,data: null);
    }
  }

  checkTokenValidity(response) {
    if (response.body is Map && response.body.containsKey('message')) {
      if (response.body['message'] == 'Access Denied') {
        tokenManager.logout();
        Get.offAll(()=>Login());
        showSnackBar(message: 'انتهت مدة الجلسة ، سجل الدخول', isError: true);
      }
    }
  }

}