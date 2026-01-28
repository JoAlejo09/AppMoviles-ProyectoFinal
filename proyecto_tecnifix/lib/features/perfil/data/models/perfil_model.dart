class PerfilModel {
  final String id;
  final String? nombre;
  final String? apellido;
  final String? celular;
  final String? rol;
  final double? latitud;
  final double? longitud;
  final String? fotoUrl;

  PerfilModel({
    required this.id,
    this.nombre,
    this.apellido,
    this.celular,
    this.rol,
    this.latitud,
    this.longitud,
    this.fotoUrl,
  });

  factory PerfilModel.fromMap(Map<String, dynamic> map) {
    return PerfilModel(
      id: map['id'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      celular: map['celular'],
      rol: map['rol'],
      latitud: map['latitud'] != null ? map['latitud'].toDouble() : null,
      longitud: map['longitud'] != null ? map['longitud'].toDouble() : null,
      fotoUrl: map['foto_url'],
    );
  }
}
