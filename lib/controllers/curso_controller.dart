import 'package:flutter/foundation.dart';
import 'package:proyecto_movil/models/curso.dart';
import 'package:proyecto_movil/services/curso_service.dart';

class CursoController extends ChangeNotifier{
  List<Curso> cursos = [];
  bool isLoading = false;
  String? error;

  Future<void> consultarPromedio(String tipo, String cedula) async {
    if(cedula.isEmpty) return;
    isLoading = true;
    cursos = [];
    error = null;
    notifyListeners();

    try {
      final resultado = await CursoService.fetchCursos(tipo, cedula);
      cursos = resultado;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading =false;
      notifyListeners();
    }
  }
}