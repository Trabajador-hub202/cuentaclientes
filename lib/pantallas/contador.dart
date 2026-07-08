import 'package:flutter/material.dart';
import 'package:contador_de_clientes/pantallas/reporte.dart'; // Verifica que la ruta de tu modelo sea correcta
import 'basededatos.dart';

class Contador extends StatefulWidget {
  const Contador({super.key});

  @override
  State<Contador> createState() => _Estadopersona();
}

class _Estadopersona extends State<Contador> {
  int persona = 0;
  int venta = 0;
  int soleado = 0;
  int nublado = 0;
  int lluvioso = 0;

  // Usamos una sola variable para controlar la fecha seleccionada
  DateTime fechaSeleccionada = DateTime.now();

  void guardar() async {
    try {
      // Creamos el objeto Reporte mapeado listo para SQLite
      final nuevoReporte = Reporte(
        fecha: fechaSeleccionada,
        personas: persona,
        ventas: venta,
        climasoleado: soleado,
        climanublado: nublado,
        climalluvioso: lluvioso,
      );

      // Guardamos usando el método correcto de tu basededatos.dart
      await servicio.insertar(nuevoReporte);

      // Corrección de ScaffoldMessenger para mostrar el mensaje flotante
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Guardado con éxito'),
            backgroundColor: Colors.green,
          ),
        );
      }

      setState(() {
        // Reiniciar valores para un nuevo conteo
        persona = 0;
        venta = 0;
        soleado = 0;
        nublado = 0;
        lluvioso = 0;
        fechaSeleccionada = DateTime.now(); // Resetea a la fecha actual
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void calendario() async {
    final DateTime? diaNuevo = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime(2026),
      lastDate: DateTime(2030),
    );
    if (diaNuevo != null) {
      setState(() {
        fechaSeleccionada = diaNuevo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Cuentaclientes'),
      ),
      body: SingleChildScrollView(
        // Se agrega scroll para evitar errores de desbordamiento de pantalla
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Persona entra a la tienda
            const Text(
              'Presione cuando una persona entre a la tienda',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                FloatingActionButton(
                  heroTag:
                      'btn_persona', // Tags únicos para evitar errores de navegación
                  onPressed: () => setState(() => persona++),
                  child: const Icon(Icons.people),
                ),
                const SizedBox(width: 20),
                Text('$persona', style: const TextStyle(fontSize: 24)),
              ],
            ),
            const SizedBox(height: 20),

            // Persona compra
            const Text(
              'Presione cuando exista una venta',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                FloatingActionButton(
                  heroTag: 'btn_venta',
                  onPressed: () => setState(() => venta++),
                  child: const Icon(Icons.attach_money),
                ),
                const SizedBox(width: 20),
                Text('$venta', style: const TextStyle(fontSize: 24)),
              ],
            ),
            const SizedBox(height: 20),

            // Climas
            const Text(
              'Seleccione el estado del clima cuando se desarrolló la venta',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'btn_soleado',
                      backgroundColor: Colors.yellow[700],
                      onPressed: () => setState(() => soleado++),
                      child: const Icon(Icons.sunny, color: Colors.white),
                    ),
                    Text('$soleado', style: const TextStyle(fontSize: 18)),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'btn_nublado',
                      backgroundColor: Colors.grey,
                      onPressed: () => setState(() => nublado++),
                      child: const Icon(Icons.cloud, color: Colors.white),
                    ),
                    Text('$nublado', style: const TextStyle(fontSize: 18)),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'btn_lluvioso',
                      backgroundColor: Colors.blue,
                      onPressed: () => setState(() => lluvioso++),
                      child: const Icon(Icons.water_drop, color: Colors.white),
                    ),
                    Text('$lluvioso', style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Espacio para guardar la fecha y guardar reporte
            Text(
              'Fecha del reporte: ${fechaSeleccionada.day}/${fechaSeleccionada.month}/${fechaSeleccionada.year}',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: calendario,
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Cambiar Fecha'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: guardar,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar Datos'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
