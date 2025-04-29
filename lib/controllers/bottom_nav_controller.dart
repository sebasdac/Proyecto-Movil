// controllers/bottom_nav_controller.dart
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs; // observable de GetX

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
