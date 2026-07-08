import 'package:contador_de_clientes/pantallas/contador.dart';
import 'package:flutter/material.dart';
import 'package:contador_de_clientes/pantallas/estadistica.dart';
import 'package:contador_de_clientes/pantallas/basededatos.dart';

//clase para la barra
class Barra extends StatefulWidget {
  const Barra({super.key});

  @override
  State<Barra> createState() => _IndiceBarra();
}

class _IndiceBarra extends State<Barra> {
  //pestañas de la aplicacion
  int indice = 0;
  final List<Widget> pantalla = [const Contador(), const Estadistica()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pantalla[indice],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indice,
        onTap: (nuevoindice) {
          setState(() {
            indice = nuevoindice;
          });
        },
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Contador'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Gráficos',
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contador de Clientes',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.purple),
      home: const Barra(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await servicio.baseDatos;
  runApp(const MyApp());
}
