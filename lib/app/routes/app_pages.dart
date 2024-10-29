import 'package:get/get.dart';
import 'package:myapp/app/modules/login/bindings/login_binding.dart';
import 'package:myapp/app/modules/login/views/login_view.dart';
import 'package:myapp/app/modules/welcome/views/welcome_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
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
  ];
}
