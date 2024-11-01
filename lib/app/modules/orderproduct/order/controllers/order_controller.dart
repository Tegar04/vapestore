// File: /lib/app/modules/Order/controllers/order_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Observables
  var products =
      <Map<String, dynamic>>[].obs; // List of products from Firestore
  var selectedProduct =
      Rx<Map<String, dynamic>?>(null); // Currently selected product
  var quantity = 1.obs;
  var discount = 0.0.obs;
  var price = 0.0.obs;
  var total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Fetch products from Firestore
  void fetchProducts() async {
    final snapshot = await firestore.collection('products').get();
    products.value = snapshot.docs.map((doc) {
      var data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();

    if (products.isNotEmpty) {
      selectProduct(0); // Automatically select the first product initially
    }
  }

  // Select product by index
  void selectProduct(int index) {
    selectedProduct.value = products[index];
    price.value = selectedProduct.value?['price']?.toDouble() ?? 0.0;
    calculateTotal();
  }

  // Calculate total with quantity and discount
  void calculateTotal() {
    total.value = (price.value * quantity.value) - discount.value;
  }

  void incrementQuantity() {
    quantity.value++;
    calculateTotal();
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
      calculateTotal();
    }
  }
}
