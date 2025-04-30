import 'package:get/get.dart';
import 'package:proyecto_movil/screens/login_view.dart';
import 'package:proyecto_movil/screens/bottom_nav_view.dart';



class AppRoutes {
  static final routes = [

    GetPage(name: '/login', page: () => LoginView()),
    GetPage(name: '/home', page: () => BottomNavView()),
    

  ];
}
