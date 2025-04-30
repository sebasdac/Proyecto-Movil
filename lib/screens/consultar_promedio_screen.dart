import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:open_file/open_file.dart';
import 'package:proyecto_movil/controllers/curso_controller.dart';
import 'package:proyecto_movil/services/bitacora_service.dart';

import 'package:proyecto_movil/utils/pdf_exporter.dart';

class ConsultarPromedioScreen extends StatefulWidget {
  const ConsultarPromedioScreen({super.key});

  @override
  State<ConsultarPromedioScreen> createState() => _ConsultarPromedioScreenState();
}

class _ConsultarPromedioScreenState extends State<ConsultarPromedioScreen> {
  //variables
  final BitacoraService _bitacoraService = BitacoraService();
  String _tipoSeleccionado = 'Nacional';
  final TextEditingController  _identificacionController = TextEditingController();
 

  
  //llamada a pdf_exporter
  Future<void> _exportarPDF(cursos) async {
    try {
      final file = await PDFExporter.exportarCursos(cursos);
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
      final controller = Provider.of<CursoController>(context);
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
                  onPressed: () {
                     controller.consultarPromedio(
                      _tipoSeleccionado,
                      _identificacionController.text.trim(),

                     );
                   _bitacoraService.ingresarBitacora(descripcion: "Consulto promedio", idUsuario: 1);

                  },
                  child: const Text("Consultar"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (controller.isLoading) const CircularProgressIndicator(),
            if (controller.error != null)
              Text(controller.error!, style: const TextStyle(color: Colors.red)),
            if (controller.cursos.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: controller.cursos.length,
                  itemBuilder: (context, index) {
                    final curso = controller.cursos[index];
                    return Card(
                      child: ListTile(
                        title: Text('Código del curso: ${curso.codigoCurso}'),
                        subtitle: Text('Nombre del curso: ${curso.nombreCurso}'),
                        trailing: Text('Promedio obtenido: ${curso.promedioObtenido}'),
                      ),
                    );
                  },

                ),
              ),
              if(controller.cursos.isNotEmpty)
               Align (
                 alignment: Alignment.centerRight,
                 child: ElevatedButton.icon(
                    onPressed:() => _exportarPDF(controller.cursos),
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