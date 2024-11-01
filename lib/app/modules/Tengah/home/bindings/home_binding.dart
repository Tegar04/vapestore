import 'package:get/get.dart';
import 'package:myapp/app/modules/Produk/product%20Viewer%20&%20Admin/controllers/product_controller.dart';
import 'package:myapp/app/modules/Produk/product%20Viewer%20&%20Admin/controllers/promo_controller.dart';



class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromoController>(() => PromoController());
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
