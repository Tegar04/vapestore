// app/modules/welcome/controllers/signup_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isLoading = false.obs;

  void setName(String value) => name.value = value;
  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;
  void setConfirmPassword(String value) => confirmPassword.value = value;

  Future<void> signUp() async {
    if (password.value != confirmPassword.value) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    isLoading.value = true;
    print("Starting signup process"); // Debug log
    try {
      // Buat akun pengguna baru di Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      print("User created, UID: ${userCredential.user!.uid}"); // Debug log

      // Simpan data pengguna ke Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name.value,
        'email': email.value,
        'uid': userCredential.user!.uid,
      });

      print("User data saved to Firestore"); // Debug log

      // Arahkan ke halaman login setelah registrasi berhasil
      Get.offNamed('/login');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Failed to sign up");
    } finally {
      isLoading.value = false;
      print("Signup process complete"); // Debug log
    }
  }
}
