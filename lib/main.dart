import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:proyecto_movil/controllers/auth_controller.dart';
import 'package:proyecto_movil/routes/app_routes.dart';

void main() async {
  await GetStorage.init();
  Get.put(AuthController());// inyectar controlador
  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
     return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: auth.token!=null ? '/home' : '/login',
      getPages: AppRoutes.routes,
     );
  }
}
