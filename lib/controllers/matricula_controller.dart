import 'package:flutter/material.dart';
import 'package:proyecto_movil/models/matricula_model.dart';
import 'package:proyecto_movil/services/matricula_service.dart';

class MatriculaController extends ChangeNotifier{
  List<Matricula> matricula = [];
  bool isLoading = false;
  String? error;

  Future<void> consultarMatricula(String cuatri, String periodo) async {
     if(cuatri.isEmpty && periodo.isEmpty) return;
     isLoading = true;
     matricula = [];
     error = null;
     notifyListeners();

     try {
      final resultados = await MatriculaService.fetchMatricula(cuatri, periodo);
      matricula = resultados;
     } catch (e) {
      error = e.toString();
     } finally {
      isLoading = false;
      notifyListeners();
     }
  }
}