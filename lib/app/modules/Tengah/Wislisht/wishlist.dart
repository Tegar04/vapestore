import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistPage extends StatelessWidget {
  final String userId = 'current_user_id'; // ID pengguna saat ini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wishlist',
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
            .collection('wishlist')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Wishlist Anda Kosong'));
          }

          final wishlistItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final product = wishlistItems[index].data() as Map<String, dynamic>;
              final String name = product['name'] ?? 'Nama Produk Tidak Tersedia';
              final int price = product['price'] ?? 0;
              final String imageUrl = product['imageUrl'] ?? 'assets/product/default.jpg';

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
                subtitle: Text('Rp $price,-'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('wishlist')
                        .doc(wishlistItems[index].id)
                        .delete();
                  },
                ),
                onTap: () {
                  // Navigasi ke halaman detail produk jika diperlukan
                },
              );
            },
          );
        },
      ),
    );
  }
}
