

class Matricula {
  final String identificacion;
  final String tipoIdentificacion;
  final String nombreCompleto;
  final String carrera;
  final String curso;
  final String grupo;

  Matricula({
    required this.identificacion,
    required this.tipoIdentificacion,
    required this.nombreCompleto,
    required this.carrera,
    required this.curso,
    required this.grupo,
  });

  factory Matricula.fromJson (Map<String, dynamic> json) {
     return Matricula(
        identificacion: json['identificacion'],
        tipoIdentificacion: json['identificacion'],
        nombreCompleto: json['NombreCompleto'],
        carrera: json ['Carrera'],
        curso: json ['Curso'],
        grupo: json ['Grupo']
     );
  }
}
