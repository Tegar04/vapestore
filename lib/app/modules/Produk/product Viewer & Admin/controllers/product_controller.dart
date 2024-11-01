import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProductController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final products = <Map<String, dynamic>>[].obs;
  final isFavorited = <RxBool>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() {
    firestore.collection('products').snapshots().listen((snapshot) {
      products.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      isFavorited.assignAll(
        List<RxBool>.generate(products.length, (_) => false.obs),
      );
    });
  }

  Future<void> addProduct({
    required String name,
    required String price,
    required File? imageFile,
  }) async {
    int? parsedPrice = int.tryParse(price);
    if (parsedPrice == null) {
      Get.snackbar("Error", "Price must be an integer value.");
      return;
    }

    String imageUrl = '';
    if (imageFile != null) {
      imageUrl = await _uploadImageToStorage(imageFile, 'product_images');
    }

    await firestore.collection('products').add({
      'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
      'price': parsedPrice,
      'imageUrl': imageUrl,
      'likes': 0,
    });
  }

  Future<void> deleteProduct(String productId) async {
    await firestore.collection('products').doc(productId).delete();
  }

  Future<void> editProduct(
    String productId, {
    required String name,
    required String price,
    required File? imageFile,
  }) async {
    int? parsedPrice = int.tryParse(price);
    if (parsedPrice == null) {
      Get.snackbar("Error", "Price must be an integer value.");
      return;
    }

    Map<String, dynamic> updatedData = {
      'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
      'price': parsedPrice,
    };

    if (imageFile != null) {
      String imageUrl = await _uploadImageToStorage(imageFile, 'product_images');
      updatedData['imageUrl'] = imageUrl;
    }

    await firestore.collection('products').doc(productId).update(updatedData);
  }

  Future<String> _uploadImageToStorage(File imageFile, String folder) async {
    Reference storageReference = storage
        .ref()
        .child('$folder/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  void toggleFavorite(int productIndex, String userId) async {
  final product = products[productIndex];
  final wishlistRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('wishlist')
      .doc(product['id']); // Misal menggunakan id unik produk

  if (isFavorited[productIndex].value) {
    await wishlistRef.delete();
    isFavorited[productIndex].value = false;
  } else {
    await wishlistRef.set({
      'name': product['name'],
      'price': product['price'],
      'imageUrl': product['imageUrl'],
    });
    isFavorited[productIndex].value = true;
  }

  //penambahan Cart
  void addToCart(int productIndex, String userId) async {
  final product = products[productIndex];
  final cartRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart')
      .doc(product['id']); // ID produk sebagai dokumen di Firestore

  await cartRef.set({
    'name': product['name'],
    'price': product['price'],
    'imageUrl': product['imageUrl'],
    'quantity': 1, // Jumlah default
  }, SetOptions(merge: true));
}


}

}
