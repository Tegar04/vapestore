import 'package:get/get.dart';
import 'package:myapp/app/modules/Produk/product/controllers/product_controller.dart';
import 'package:myapp/app/modules/Produk/product/controllers/promo_controller.dart';



class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromoController>(() => PromoController());
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
