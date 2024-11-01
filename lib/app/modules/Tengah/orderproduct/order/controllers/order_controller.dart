// File: /lib/app/modules/Tengah/orderproduct/order/controllers/order_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Observables
  var products = <Map<String, dynamic>>[].obs;
  var selectedProduct = Rx<Map<String, dynamic>?>(null);
  var quantity = 1.obs;
  var discount = 0.0.obs;
  var price = 0.0.obs;
  var total = 0.0.obs;

  // Vouchers and selected voucher
  var vouchers = <Map<String, dynamic>>[].obs;
  var selectedVoucher = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchVouchers();
  }

  void fetchProducts() async {
    final snapshot = await firestore.collection('products').get();
    products.value = snapshot.docs.map((doc) {
      var data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();

    if (products.isNotEmpty) {
      selectProduct(0);
    }
  }

  void fetchVouchers() async {
    final snapshot = await firestore.collection('vouchers').get();
    vouchers.value = snapshot.docs.map((doc) {
      var data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  void selectProduct(int index) {
    selectedProduct.value = products[index];
    price.value = selectedProduct.value?['price']?.toDouble() ?? 0.0;
    calculateTotal();
  }

  void selectVoucher(Map<String, dynamic> voucher) {
    selectedVoucher.value = voucher;
    discount.value = (price.value * (voucher['discount'] ?? 0) / 100);
    calculateTotal();
  }

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

  Future<void> submitOrder() async {
    if (selectedProduct.value == null) return;

    final orderData = {
      'productId': selectedProduct.value?['id'],
      'productName': selectedProduct.value?['name'],
      'quantity': quantity.value,
      'price': price.value,
      'discount': discount.value,
      'total': total.value,
      'orderDate': DateTime.now(),
      // Tambahkan detail lain seperti user ID atau alamat pengiriman jika diperlukan
    };

    try {
      await firestore.collection('orders').add(orderData);
      Get.snackbar('Success', 'Order has been placed successfully!');
      Get.toNamed('/done'); // Pindah ke halaman selanjutnya setelah sukses
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order: $e');
    }
  }
}
