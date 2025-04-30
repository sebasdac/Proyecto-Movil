import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/controllers/matricula_controller.dart';
import 'package:proyecto_movil/services/bitacora_service.dart';
import 'package:proyecto_movil/utils/pdf_exporter_matricula.dart';

class ConsultarMatriculaView  extends StatefulWidget{
  const ConsultarMatriculaView({super.key});
  @override
  State<ConsultarMatriculaView> createState() => _ConsultarPromedioScreenState();
}

class _ConsultarPromedioScreenState extends State<ConsultarMatriculaView> {
  //variables
  final BitacoraService _bitacoraService = BitacoraService();
  String? _periodoSeleccionado;
  String? _cuatriSeleccioando;
  //llamada a pdf exporter
  Future<void> _exportarPDF(matricula) async {
    try {
      final file = await PDFExporterMatricula.exportarCursos(matricula);
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
  Widget build (BuildContext context){
    final controller = Provider.of<MatriculaController>(context);

    return Scaffold(
       appBar: AppBar(
        title: const Text('Consulta de matricula')
       ),
       body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             Row(
              children: [
                DropdownButton<String>(
                  value: _cuatriSeleccioando,
                  hint: const Text("Seleccione un cuatrimestre"),
                  items: const[
                    DropdownMenuItem(value: '1', child: Text('1')),
                    DropdownMenuItem(value: '2', child: Text('2')),
                    DropdownMenuItem(value: '3', child: Text('3')),
                  ],
                  onChanged: (value){
                    if(value!=null){
                      setState(() {
                        _cuatriSeleccioando = value;
                      });
                    }
                  }),
                  DropdownButton<String>(
                  value: _periodoSeleccionado,
                  hint: const Text("Seleccione un periodo"),
                  items: const[
                    DropdownMenuItem(value: '2024', child: Text('2024')),
                    DropdownMenuItem(value: '2025', child: Text('2025')),
                  ],
                  onChanged: (value){
                    if(value!=null){
                      setState(() {
                        _periodoSeleccionado = value;
                      });
                    }
                  }),
                ]
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  if(_cuatriSeleccioando == null || _periodoSeleccionado ==null){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content : Text('Debe seleccionar cuatrimestre y periodo'))
                    );
                    return;
                  }
                  _bitacoraService.ingresarBitacora(descripcion: "Consulto matricula", idUsuario: 1);
                  controller.consultarMatricula(_cuatriSeleccioando!, _periodoSeleccionado!);
                },
                child: const Text("Consultar"),
              ),
              const SizedBox(height: 20),
              if(controller.isLoading) const CircularProgressIndicator(),
              if(controller.error != null)
               Text(controller.error!, style: const TextStyle(color: Colors.red)),
              if(controller.matricula.isNotEmpty)
              Align (
                 alignment: Alignment.centerRight,
                 child: ElevatedButton.icon(
                    onPressed:() => _exportarPDF(controller.matricula),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("Exportar a PDF"),

                 ),
                ),
            
              if(controller.matricula.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.matricula.length,
                    itemBuilder: (context, index) {
                      final matricula = controller.matricula[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                 matricula.identificacion,
                                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text("Tipo de identificación ${matricula.tipoIdentificacion}"),
                                Text("Identificacion: ${matricula.identificacion}"),
                                Text("Nombre completo: ${matricula.nombreCompleto}"),
                                Text("Carrera: ${matricula.carrera}"),
                                Text("Curso: ${matricula.curso}"),
                                Text("Grupo: ${matricula.grupo}")
                                
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                )    
          ]
          
        ),
       ),
    );
  }
}