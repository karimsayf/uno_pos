import 'package:get/get.dart';
import 'api_crud_services.dart';
import 'token_manager.dart';

class AppBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<TokenManager>(TokenManager());
    Get.put<APICrudServices>(APICrudServices());
  }
}