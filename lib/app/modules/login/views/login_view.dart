import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/gestures.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 40),
                  _buildLoginForm(),
                  const SizedBox(height: 20),
                  _buildForgotPasswordLink(),
                  const SizedBox(height: 10),
                  _buildSignUpLink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membuat background gambar
  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/logo/background.png',
        fit: BoxFit.cover,
      ),
    );
  }

  // Fungsi untuk judul
  Widget _buildTitle() {
    return const Text(
      'WELCOME',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // Fungsi untuk form login (email, password, dan tombol login)
  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildEmailField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 20),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      onChanged: controller.setEmail,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      onChanged: controller.setPassword,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(() => ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.login,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            minimumSize: const Size(250, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator()
              : const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ));
  }

  // Fungsi untuk link "Forgot Password"
  Widget _buildForgotPasswordLink() {
    return TextButton(
      onPressed: () {
        Get.toNamed('/email');
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // Fungsi untuk link "Sign Up"
  Widget _buildSignUpLink() {
    return RichText(
      text: TextSpan(
        text: "Don’t have an account? ",
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        children: [
          TextSpan(
            text: 'Sign Up',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed('/signup');
              },
          ),
        ],
      ),
    );
  }
}
