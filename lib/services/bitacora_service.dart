import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_movil/models/bitacora_model.dart';
import 'package:get_storage/get_storage.dart';

class BitacoraService {
  final String endpoint = 'https://tiusr7pl.cuc-carrera-ti.ac.cr/api_bitacora/api/bitacora';


  Future<http.Response> ingresarBitacora({
    required String descripcion,
    required int idUsuario,
  }) async {
    final storage = GetStorage();
    final token = storage.read('token');
    final refreshToken = storage.read('refresh_token');

    final bitacora = Bitacora(
      descripcion: descripcion,
      idUsuario: idUsuario,
    );

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'refreshToken': refreshToken ?? '',
    };

    final body = json.encode(bitacora.toJson());

    return await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: body,
    );
  }
}
