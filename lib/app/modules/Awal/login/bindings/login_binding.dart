// app/modules/login/bindings/login_binding.dart
import 'package:get/get.dart';
import 'package:myapp/app/modules/Awal/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
