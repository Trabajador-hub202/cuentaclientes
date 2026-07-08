import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:contador_de_clientes/pantallas/reporte.dart';

class BaseDatosServicio {
  static final BaseDatosServicio _instancia = BaseDatosServicio._interno();
  factory BaseDatosServicio() => _instancia;
  BaseDatosServicio._interno();

  Database? _baseDatos;
  final StreamController<List<Reporte>> _controladorReportes =
      StreamController<List<Reporte>>.broadcast();

  Future<Database> get baseDatos async {
    if (_baseDatos != null) return _baseDatos!;
    _baseDatos = await _inicializarDB();
    return _baseDatos!;
  }

  Future<Database> _inicializarDB() async {
    final rutaDB = await getDatabasesPath();
    final ruta = join(rutaDB, 'contador_clientes.db');

    return await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reportes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fecha TEXT NOT NULL, -- Nueva columna agregada para la fecha
            personas INTEGER NOT NULL,
            ventas INTEGER NOT NULL,
            climasoleado INTEGER NOT NULL,
            climanublado INTEGER NOT NULL,
            climalluvioso INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Stream<List<Reporte>> escuchar() {
    _actualizarStream();
    return _controladorReportes.stream;
  }

  Future<void> _actualizarStream() async {
    final lista = await obtenerTodos();
    if (!_controladorReportes.isClosed) {
      _controladorReportes.add(lista);
    }
  }

  Future<List<Reporte>> obtenerTodos() async {
    final db = await baseDatos;
    final List<Map<String, dynamic>> mapas = await db.query(
      'reportes',
      orderBy: 'id DESC',
    );
    return mapas.map((mapa) => Reporte.fromMap(mapa)).toList();
  }

  Future<int> insertar(Reporte reporte) async {
    final db = await baseDatos;
    final resultado = await db.insert('reportes', reporte.toMap());
    await _actualizarStream();
    return resultado;
  }

  Future<int> limpiar() async {
    final db = await baseDatos;
    final resultado = await db.delete('reportes');
    await _actualizarStream();
    return resultado;
  }
}

final servicio = BaseDatosServicio();
