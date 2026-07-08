//estructura de los datos que se guardaran diariamente en la base de datos

class Reporte {
  final int? id;
  final DateTime fecha;
  final int personas;
  final int ventas;
  final int climasoleado;
  final int climalluvioso;
  final int climanublado;

  Reporte({
    this.id,
    required this.fecha,
    required this.personas,
    required this.ventas,
    required this.climasoleado,
    required this.climalluvioso,
    required this.climanublado,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'fecha': fecha.toIso8601String(), // Guarda la fecha legible
      'personas': personas,
      'ventas': ventas,
      'climasoleado': climasoleado,
      'climanublado': climanublado,
      'climalluvioso': climalluvioso,
    };
  }

  factory Reporte.fromMap(Map<String, dynamic> map) {
    return Reporte(
      id: map['id'] as int?,
      fecha: DateTime.parse(
        map['fecha'] as String? ?? DateTime.now().toIso8601String(),
      ),
      personas: map['personas'] as int? ?? 0,
      ventas: map['ventas'] as int? ?? 0,
      climasoleado: map['climasoleado'] as int? ?? 0,
      climanublado: map['climanublado'] as int? ?? 0,
      climalluvioso: map['climalluvioso'] as int? ?? 0,
    );
  }
}
