class Bitacora {
  final String descripcion;
  final int idUsuario;

  Bitacora({
    required this.descripcion,
    required this.idUsuario,
  });

  Map<String, dynamic> toJson() => {
        'Descripcion': descripcion,
        'IdUsuario': idUsuario,
      };
}
