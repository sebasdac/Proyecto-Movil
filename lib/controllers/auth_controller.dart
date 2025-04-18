import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final storage = GetStorage();
  var isLoading = false.obs;
  var user = Rxn<User>();

  final AuthService _authService = AuthService();

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    try {
      final loggedUser = await _authService.login(username, password);
      user.value = loggedUser;

      // Guardar token en memoria y localmente
      storage.write('token', loggedUser?.accessToken);
      storage.write('refresh_token', loggedUser?.refreshToken);
      storage.write('username', loggedUser?.usuarioID);

      Get.snackbar('Éxito', 'Sesión iniciada');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String? get token => storage.read('token');
  String? get refreshToken => storage.read('refresh_token');

  void logout() {
    user.value = null;
    storage.erase();
    Get.offAllNamed('/login');
  }
}
