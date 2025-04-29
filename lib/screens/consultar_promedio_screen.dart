import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:proyecto_movil/models/curso.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_movil/utils/pdf_exporter.dart';

class ConsultarPromedioScreen extends StatefulWidget {
  const ConsultarPromedioScreen({super.key});

  @override
  State<ConsultarPromedioScreen> createState() => _ConsultarPromedioScreenState();
}

class _ConsultarPromedioScreenState extends State<ConsultarPromedioScreen> {
  //variables
  String _tipoSeleccionado = 'Nacional';
  final TextEditingController  _identificacionController = TextEditingController();
  List<Curso> _cursos = []; //instancia de cursos
  bool _isLoading = false; //indicador de carga
  String? _error;
  //metodos 

  //consultar promedios
  Future<void> _consultarPromedio() async {
    final storage = GetStorage();
    final token = storage.read('token');
    final cedula = _identificacionController.text.trim();
    if (cedula.isEmpty) return; //si la manda vacia, no hace nada

    setState(() {
      _isLoading = true;
      _cursos = [];
      _error = null;
    });

    final url = Uri.parse('http://ti-usr3-cp.cuc-carrera-ti.ac.cr:1434/api/historialacademico/$_tipoSeleccionado/$cedula');

    try { //empezamos el fecth
      final response = await http.get(
        url,
        headers : {
          'Authorization' : 'Bearer $token'
        }
      );
      if (response.statusCode == 200){
          final List<dynamic> jsonData = json.decode(response.body);
          final cursos = jsonData.map((e) => Curso.fromJson(e)).toList();
          setState((){
            _cursos = cursos.cast<Curso>();
          });
      } else {
        setState((){
          _error = 'Error al consultar: ${response.statusCode}';
        });
      }

    } catch (e) {
      setState((){
        _error = "Ocurrio un error: $e";
      });
    } finally {
      setState((){
        _isLoading = false;
      }); 
    }
  }
  
  //llamada a pdf_exporter
  Future<void> _exportarPDF() async {
    try {
      final file = await PDFExporter.exportarCursos(_cursos);
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF generado correctamente, abriendo...')),
        );
      }
      await OpenFile.open(file.path);
    } catch (e){
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar PDF: $e')),
        );
      }
      
    }
  }
  
  //pantalla
  @override

    Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de promedios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: _tipoSeleccionado,
                  items: const [
                    DropdownMenuItem(value: 'Nacional', child: Text('Nacional')),
                    DropdownMenuItem(value: 'Extranjero', child: Text("Extranjero"))
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _tipoSeleccionado = value;
                      });
                    }
                  },
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: _identificacionController,
                    decoration: const InputDecoration(
                      labelText: 'Identificación',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _consultarPromedio,
                  child: const Text("Consultar"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_cursos.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _cursos.length,
                  itemBuilder: (context, index) {
                    final curso = _cursos[index];
                    return Card(
                      child: ListTile(
                        title: Text(curso.nombreCurso),
                        subtitle: Text('Código del curso: ${curso.codigoCurso}'),
                        trailing: Text('Promedio: ${curso.promedioObtenido}'),
                      ),
                    );
                  },

                ),
              ),
              if(_cursos.isNotEmpty)
               Align (
                 alignment: Alignment.centerRight,
                 child: ElevatedButton.icon(
                    onPressed: _exportarPDF,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("Exportar a PDF"),

                 ),
                )

          ],
        ),
      ),
    );
  }


}