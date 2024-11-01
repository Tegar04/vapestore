// File: /lib/app/modules/Order/views/order_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.toNamed('/welcome'),
        ),
        title: Text('Order'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.selectedProduct.value == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildOrderDetail(),
            _buildStoreAddress(),
            _buildProductItem(),
            _buildDiscountSection(),
            _buildPaymentSummary(),
            _buildPaymentMethod(),
            _buildOrderButton(),
          ],
        );
      }),
    );
  }

  Widget _buildOrderDetail() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Order Detail',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreAddress() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Store Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Jl. Kpg Sutoyo'),
            Text('Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai.'),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Obx(() {
          final product = controller.selectedProduct.value;
          final quantity = controller.quantity.value;
          if (product == null) return SizedBox.shrink();

          return Row(
            children: [
              Image.network(
                product['imageUrl'] ?? 'assets/product/default.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product['name'] ?? 'Product Name',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(product['price'] != null
                        ? 'Rp ${product['price']},-'
                        : 'No Price'),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: controller.decrementQuantity),
                  Text('$quantity'),
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: controller.incrementQuantity),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDiscountSection() {
    return Card(
      child: InkWell(
        onTap: () => Get.toNamed('/voucher'),
        child: ListTile(
          title: Text('1 Discount is Applied'),
          trailing: Icon(Icons.chevron_right),
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

  Widget _buildPaymentMethod() {
    return Card(
      child: InkWell(
        onTap: () => Get.toNamed('/payment'),
        child: ListTile(
          leading: Icon(Icons.payment),
          title: Text('Cash/QRIS'),
          subtitle: Text('Rp ${controller.total.value.toStringAsFixed(0)}'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  Widget _buildOrderButton() {
    return ElevatedButton(
      child: Text('Order'),
      onPressed: () => Get.toNamed('/scan'),
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: Colors.white),
    );
  }
}
