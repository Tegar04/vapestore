// app/modules/welcome/bindings/signup_binding.dart
import 'package:get/get.dart';
import 'package:myapp/app/modules/Awal/register/controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
  }
}
