

class Curso {
  final int codigoCurso;
  final String nombreCurso;
  final int promedioObtenido;

  Curso({
    required this.codigoCurso,
    required this.nombreCurso,
    required this.promedioObtenido,
  });

  factory Curso.fromJson(Map<String, dynamic> json) {
     return Curso(
      codigoCurso: json['CodigoCurso'],
      nombreCurso: json['NombreCurso'],
      promedioObtenido: json ['PromedioObtenido']
     );
  }
}