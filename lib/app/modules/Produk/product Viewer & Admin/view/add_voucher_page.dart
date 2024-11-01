// lib/app/modules/Produk/product Viewer & Admin/view/add_voucher_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/voucher_controller.dart';

class AddVoucherPage extends StatefulWidget {
  const AddVoucherPage({Key? key}) : super(key: key);

  @override
  _AddVoucherPageState createState() => _AddVoucherPageState();
}

class _AddVoucherPageState extends State<AddVoucherPage> {
  final VoucherController voucherController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Voucher'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Voucher',
                ),
              ),
              TextField(
                controller: discountController,
                decoration: const InputDecoration(
                  labelText: 'Diskon (%)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await voucherController.addVoucher(
                    title: titleController.text,
                    discount: discountController.text,
                  );
                  Get.back();
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
