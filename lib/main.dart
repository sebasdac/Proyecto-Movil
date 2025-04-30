import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'package:proyecto_movil/controllers/auth_controller.dart';
import 'package:proyecto_movil/controllers/curso_controller.dart';
import 'package:proyecto_movil/controllers/matricula_controller.dart';
import 'package:proyecto_movil/routes/app_routes.dart';

void main() async {
  await GetStorage.init();
  Get.put(AuthController()); // Inyectar controlador de GetX

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CursoController()),
        ChangeNotifierProvider(create: (_) => MatriculaController()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: auth.token != null ? '/home' : '/login',
        getPages: AppRoutes.routes,
      ),
    );
  }
}
