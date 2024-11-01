import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatelessWidget {
  final String userId = 'current_user_id'; // Ganti dengan ID pengguna yang sebenarnya

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Keranjang Anda Kosong'));
          }

          final cartItems = snapshot.data!.docs;

          // Menghitung total harga
          int totalPrice = cartItems.fold<int>(0, (sum, item) {
            final itemData = item.data() as Map<String, dynamic>;
            final int price = itemData['price'] ?? 0;
            final int quantity = itemData['quantity'] ?? 1;
            return sum + (price * quantity);
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartItems[index].data() as Map<String, dynamic>;
                    final String name = product['name'] ?? 'Nama Produk Tidak Tersedia';
                    final int price = product['price'] ?? 0;
                    final String imageUrl = product['imageUrl'] ?? 'assets/product/default.jpg';
                    final int quantity = product['quantity'] ?? 1;

                    return ListTile(
                      leading: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/product/default.jpg');
                        },
                      ),
                      title: Text(name),
                      subtitle: Text('Rp $price,- x $quantity'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .collection('cart')
                              .doc(cartItems[index].id)
                              .delete();
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: Rp $totalPrice,-',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    checkout(cartItems, userId);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Beli Sekarang',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Future<void> checkout(List<DocumentSnapshot> cartItems, String userId) async {
    for (var item in cartItems) {
      await item.reference.delete();
    }
    Get.snackbar('Pembelian Berhasil', 'Terima kasih telah berbelanja!', snackPosition: SnackPosition.BOTTOM);
  }
}
