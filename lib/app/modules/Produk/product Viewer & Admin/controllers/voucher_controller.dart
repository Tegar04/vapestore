// lib/app/modules/Produk/product Viewer & Admin/controllers/voucher_controller.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final vouchers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVouchers();
  }

  void fetchVouchers() {
    firestore.collection('vouchers').snapshots().listen((snapshot) {
      vouchers.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;

        // Pastikan discount diubah ke int jika diperlukan
        if (data['discount'] is String) {
          data['discount'] = int.tryParse(data['discount']) ?? 0;
        }

        return data;
      }).toList();
    });
  }

  Future<void> addVoucher(
      {required String title, required String discount}) async {
    int? parsedDiscount = int.tryParse(discount);
    if (parsedDiscount == null || parsedDiscount <= 0 || parsedDiscount > 100) {
      Get.snackbar("Error", "Diskon harus berupa angka antara 1 hingga 100.");
      return;
    }

    await firestore.collection('vouchers').add({
      'title': title.isNotEmpty ? title : 'Nama Voucher Tidak Tersedia',
      'discount': parsedDiscount,
    });
  }

  Future<void> deleteVoucher(String voucherId) async {
    await firestore.collection('vouchers').doc(voucherId).delete();
  }
}
