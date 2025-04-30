// bottom_nav_view.dart
import 'package:flutter/material.dart';
import 'package:proyecto_movil/screens/consultar_matricula_view.dart';
import 'package:proyecto_movil/screens/home_view.dart';
import 'package:proyecto_movil/screens/consultar_promedio_screen.dart';


class BottomNavView extends StatefulWidget {
  @override
  _BottomNavViewState createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeView(),
    ConsultarPromedioScreen(),
    ConsultarMatriculaView(),
   
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // cambia la página
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Promedios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.functions),
            label: 'Matricula',
          ),
        ],
      ),
    );
  }
}
