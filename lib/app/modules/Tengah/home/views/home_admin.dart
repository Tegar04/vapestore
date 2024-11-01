// lib/app/modules/home_admin_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/Produk/product%20Viewer%20&%20Admin/controllers/product_controller.dart';
import 'package:myapp/app/modules/Produk/product%20Viewer%20&%20Admin/controllers/promo_controller.dart';
import 'package:myapp/app/modules/Produk/product%20Viewer%20&%20Admin/view/add_product_page.dart';
import 'package:myapp/app/modules/Produk/product%20Viewer%20&%20Admin/view/add_promo_page.dart';
import 'package:myapp/app/modules/Produk/product%20Viewer%20&%20Admin/view/edit_product_page.dart';
import 'package:myapp/app/modules/Produk/product%20Viewer%20&%20Admin/view/edit_promo_page.dart';
import 'package:myapp/app/modules/Produk/product%20Viewer%20&%20Admin/widgets/admin_product_card.dart';
import 'package:myapp/app/modules/Produk/product%20Viewer%20&%20Admin/widgets/admin_promo_card.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomePage> {
  final PromoController promoController = Get.put(PromoController());
  final ProductController productController = Get.put(ProductController());


  @override
  void initState() {
    super.initState();
    // Pastikan aplikasi siap menerima notifikasi dalam semua kondisi
    
  }

  void _addNewProduct() {
    Get.to(() => const AddProductPage());
  }

  void _addNewPromo() {
    Get.to(() => const AddPromoPage());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Navigasi ke halaman daftar notifikasi
                
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Tombol untuk memicu notifikasi
              
              // Product Management Section
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Manage Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              // Product GridView
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                  () => GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: productController.products.length,
                    itemBuilder: (context, index) {
                      var product = productController.products[index];
                      return AdminProductCard(
                        image: product['imageUrl'] ?? '',
                        name: product['name'] ?? 'Nama Produk',
                        price: 'Rp ${product['price'] ?? 0}',
                        onEdit: () {
                          Get.to(() => EditProductPage(productId: product['id']));
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus Produk'),
                              content: const Text(
                                  'Apakah Anda yakin ingin menghapus produk ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    productController.deleteProduct(product['id']);
                                    Get.back();
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              // Promotion Management Section
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Manage Promotions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              // Promotion GridView
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                  () => GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: promoController.promoItems.length,
                    itemBuilder: (context, index) {
                      var promo = promoController.promoItems[index];
                      return AdminPromoCard(
                        image: promo.imageUrl,
                        title: promo.titleText,
                        description: promo.promoDescriptionText,
                        onEdit: () {
                          Get.to(() => EditPromoPage(promoId: promo.id ?? ''));
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus Promo'),
                              content: const Text(
                                  'Apakah Anda yakin ingin menghapus promo ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    promoController.deletePromo(promo.id ?? '');
                                    Get.back();
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.add_box),
                    title: const Text('Tambah Produk'),
                    onTap: () {
                      Get.back();
                      _addNewProduct();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.local_offer),
                    title: const Text('Tambah Promo'),
                    onTap: () {
                      Get.back();
                      _addNewPromo();
                    },
                  ),
                ],
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      );
}
