import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/register/controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SIGN UP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Enter Your Name',
                    onChanged: controller.setName,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Email',
                    onChanged: controller.setEmail,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Password',
                    onChanged: controller.setPassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Re-enter Password',
                    onChanged: controller.setConfirmPassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.signUp,
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Sign Up'),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    bool obscureText = false,
  }) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
