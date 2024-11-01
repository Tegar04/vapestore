import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/app/routes/app_pages.dart'; // Ganti sesuai path routing Anda
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Inisialisasi Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      initialRoute: '/homeadminpage', // Tentukan halaman awal
      getPages: AppPages.routes, // Gunakan route yang sudah terdaftar
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
