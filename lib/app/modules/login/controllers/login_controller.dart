import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      await _auth.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      Get.offNamed('/home'); // Berpindah ke halaman HomeView
    } on FirebaseAuthException catch (e) {
      loginError.value = e.message ?? "An error occurred";
    } finally {
      isLoading.value = false;
    }
  }
}
