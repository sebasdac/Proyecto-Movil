import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import "package:http/http.dart" as http;
import '../models/curso.dart';

class CursoService {
  static Future<List<Curso>> fetchCursos(String tipo, String cedula) async {
     final storage = GetStorage();
     final token = storage.read('token');
     final url = Uri.parse('http://ti-usr3-cp.cuc-carrera-ti.ac.cr:1434/api/historialacademico/$tipo/$cedula');

     final response = await http.get(
      url,
      headers: {
        'Authorization' : 'Bearer $token'
      },
      
     );
     if (response.statusCode == 200){
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Curso.fromJson(e)).toList();// pasar el json a el modelo

     } else {
      throw Exception('Error al consultar: ${response.statusCode}');
     }
  }
}