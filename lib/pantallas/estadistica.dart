import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:contador_de_clientes/pantallas/reporte.dart';
import 'basededatos.dart';

class Estadistica extends StatelessWidget {
  const Estadistica({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Estadística'),
        shadowColor: Colors.purple,
      ),
      body: StreamBuilder<List<Reporte>>(
        stream: servicio.escuchar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aún no hay reportes guardados.'));
          }
          final reporte = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                const Text('Personas que ingresaron y compraron'),
                SizedBox(height: 200, child: _graficopastel(reporte)),
                const SizedBox(height: 10),
                const Text('Influencia del clima en las ventas'),
                SizedBox(height: 300, child: _graficobarras(reporte)),
                const SizedBox(height: 40),

                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Eliminar datos'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text(
                            '¿Desea borrar todos los registros?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('No'),
                            ),
                            TextButton(
                              child: const Text('Sí'),
                              onPressed: () async {
                                Navigator.pop(dialogContext);
                                final TextEditingController pinseguridad =
                                    TextEditingController();

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Ingrese la contraseña:',
                                      ),
                                      content: TextField(
                                        controller: pinseguridad,
                                        obscureText: true,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            const String acceso =
                                                '0000'; //  clave de seguridad
                                            if (pinseguridad.text == acceso) {
                                              Navigator.pop(
                                                context,
                                              ); // Cierra diálogo de PIN
                                              // Llama al borrado
                                              await servicio.limpiar();
                                            }
                                          },
                                          child: const Text('Confirmar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _graficopastel(List<Reporte> reporte) {
    int totalpersona = 0;
    int totalventa = 0;
    final quincena = reporte.take(15).toList();
    for (var i in quincena) {
      totalpersona += i.personas;
      totalventa += i.ventas;
    }
    if (totalpersona == 0) {
      totalpersona = 1;
    }
    double porcentventa = (totalventa / totalpersona) * 100;
    double porcentvisitas = (100 - porcentventa);
    if (porcentventa > 100) {
      porcentventa = 100;
      porcentvisitas = 0;
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        sections: [
          PieChartSectionData(
            color: Colors.green,
            value: porcentvisitas,
            title: '${porcentvisitas.toStringAsFixed(1)}%\nIngresaron',
          ),
          PieChartSectionData(
            color: const Color.fromARGB(255, 58, 86, 179),
            value: porcentventa,
            title: '${porcentventa.toStringAsFixed(1)}%\nCompraron',
          ),
        ],
      ),
    );
  }

  Widget _graficobarras(List<Reporte> reporte) {
    int soleado = 0;
    int nublado = 0;
    int lluvioso = 0;
    final quincena = reporte.take(15).toList();
    for (var i in quincena) {
      soleado += i.climasoleado;
      nublado += i.climanublado;
      lluvioso += i.climalluvioso;
    }
    int maxVenta = [soleado, nublado, lluvioso].reduce((a, b) => a > b ? a : b);
    double limiteY = maxVenta == 0 ? 10 : (maxVenta + (maxVenta * 0.15));
    return BarChart(
      BarChartData(
        maxY: limiteY,
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Soleado', style: TextStyle(fontSize: 14)),
                    );
                  case 1:
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Nublado', style: TextStyle(fontSize: 14)),
                    );
                  case 2:
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Lluvioso', style: TextStyle(fontSize: 14)),
                    );
                  default:
                    return const Text('');
                }
              },
            ),
          ),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: soleado.toDouble(),
                color: Colors.yellow,
                width: 15,
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: nublado.toDouble(),
                color: const Color.fromARGB(255, 187, 186, 180),
                width: 15,
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: lluvioso.toDouble(),
                color: const Color.fromARGB(255, 123, 176, 197),
                width: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
