import 'package:get/get.dart';
import 'package:myapp/app/modules/Awal/login/bindings/login_binding.dart';
import 'package:myapp/app/modules/Awal/login/views/login_view.dart';
import 'package:myapp/app/modules/Awal/register/bindings/signup_binding.dart';
import 'package:myapp/app/modules/Awal/register/views/signup_view.dart';
import 'package:myapp/app/modules/Awal/welcome/views/welcome_view.dart';
import '../modules/Tengah/home/bindings/home_binding.dart';
import '../modules/Tengah/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.WELCOME,
      page: () => WelcomeView(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
  ];
}
