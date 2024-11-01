import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var loginError = ''.obs;

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;

  Future<void> login() async {
    isLoading.value = true;
    loginError.value = '';

    if (email.value.isEmpty || password.value.isEmpty) {
      loginError.value = "Email and password cannot be empty.";
      isLoading.value = false;
      return;
    }

    try {
      // Login menggunakan Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      // Ambil data pengguna dari Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];
        if (role == 'admin') {
          Get.toNamed('/homeadmin'); // Berpindah ke halaman Admin
        } else {
          Get.toNamed('/home'); // Berpindah ke halaman HomeView
        }
      } else {
        loginError.value = "User data not found.";
      }
    } on FirebaseAuthException catch (e) {
      loginError.value = e.message ?? "An error occurred";
    } finally {
      isLoading.value = false;
    }
  }
}
