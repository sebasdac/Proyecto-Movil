import 'dart:io';

import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/curso.dart';

class PDFExporter {
  static Future<File> exportarCursos(List<Curso> cursos) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Historial Académico',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              ...cursos.map((curso) => pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(child: pw.Text('${curso.nombreCurso}')),
                    pw.Text('Código: ${curso.codigoCurso}'),
                    pw.Text('Promedio: ${curso.promedioObtenido}'),
                  ],
                ),
              )),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/historial_academico.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
