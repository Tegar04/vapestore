// app/modules/login/bindings/login_binding.dart
import 'package:get/get.dart';
import 'package:myapp/app/modules/Tengah/orderproduct/order/controllers/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
  }
}
