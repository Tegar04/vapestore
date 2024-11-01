import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';

class VoucherView extends GetView<OrderController> {
  const VoucherView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text('Voucher'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildVoucherList(),
                _buildVoucherItems(),
                Divider(),
                _buildPaymentSummary(),
              ],
            ),
          ),
          _buildDoneButton(),
        ],
      ),
    );
  }

  Widget _buildVoucherList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          'Voucher List',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildVoucherItems() {
    return Obx(() {
      if (controller.vouchers.isEmpty) {
        return Center(child: Text("No vouchers available"));
      }

      return Column(
        children: controller.vouchers.map((voucher) {
          return _buildVoucherItem(
            voucher['title'] ?? 'Untitled Voucher',
            Colors.orange,
            voucher['discount'] ?? 0, // Using discount field from Firestore
            voucher,
          );
        }).toList(),
      );
    });
  }

  Widget _buildVoucherItem(
    String title,
    Color color,
    int discountPercentage,
    Map<String, dynamic> voucher,
  ) {
    bool isSelected = controller.selectedVoucher.value == voucher;

    return GestureDetector(
      onTap: () => controller.selectVoucher(voucher),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(Icons.local_offer,
                color: isSelected ? Colors.white : Colors.black),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "$title - $discountPercentage% Off",
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                color: isSelected ? Colors.white : Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Price'),
              Obx(() =>
                  Text('Rp ${controller.price.value.toStringAsFixed(0)}')),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Discount'),
              Obx(() =>
                  Text('Rp ${controller.discount.value.toStringAsFixed(0)}')),
            ]),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => Text('Rp ${controller.total.value.toStringAsFixed(0)}',
                  style: TextStyle(fontWeight: FontWeight.bold))),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed('/order'); // Navigate back to Order page
        },
        child: Text('Done'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
