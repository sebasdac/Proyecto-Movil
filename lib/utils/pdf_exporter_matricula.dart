import 'dart:io';

import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:proyecto_movil/models/matricula_model.dart';


class PDFExporterMatricula {
  static Future<File> exportarCursos(List<Matricula> matricula) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Matrícula del cuatrimestre',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              ...matricula.map((matricula) => pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 8),
                decoration: pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Nombre completo: ${matricula.nombreCompleto}'),
                    pw.Text('Identificación: ${matricula.identificacion} (${matricula.tipoIdentificacion})'),
                    pw.Text('Carrera: ${matricula.carrera}'),
                    pw.Text('Curso: ${matricula.curso}'),
                    pw.Text('Grupo: ${matricula.grupo}'),
                  ],
                ),
              )),
            ],

          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/matricula.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
