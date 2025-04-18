import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';


class HomeView extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final user = authController.user.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${user?.usuarioID ?? 'Usuario'}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
          )
        ],
      ),
      body: Center(
        child: Text('Token: ${user?.accessToken ?? ''}'),
      ),
    );
  }
}
