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
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
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

      isLoading.value = false; // Set loading ke false sebelum navigasi
      Get.offNamed('/login'); // Navigasi ke halaman login
      print("Navigated to login page"); // Debug log
    } on FirebaseAuthException catch (e) {
      isLoading.value = false; // Set ke false jika terjadi error
      print("FirebaseAuthException: ${e.message}"); // Debug log untuk error
      Get.snackbar("Error", e.message ?? "Failed to sign up");
    } catch (e) {
      isLoading.value = false;
      print("Exception: $e"); // Debug log untuk exception umum
      Get.snackbar("Error", "An unexpected error occurred");
    } finally {
      isLoading.value = false; // Set loading ke false di akhir
      print("Signup process complete"); // Debug log
    }
  }
}
