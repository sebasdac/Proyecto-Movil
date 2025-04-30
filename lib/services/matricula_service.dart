import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:proyecto_movil/models/matricula_model.dart';
import 'package:http/http.dart' as http;

class MatriculaService {
  static Future<List<Matricula>> fetchMatricula(cuatri, periodo) async {
    final storage = GetStorage();
    final token = storage.read('token');
    final url = Uri.parse(
      'http://ti-usr3-cp.cuc-carrera-ti.ac.cr:1434/api/matricula/listadoestudiantes/$cuatri/$periodo'
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization' : 'Bearer $token'
      }
    );
    if (response.statusCode ==200){
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e)=> Matricula.fromJson(e)).toList();
    } else {
      throw Exception('Error al consultar matricula: ${response.statusCode}');
    }
  }
}