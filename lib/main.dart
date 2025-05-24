import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_gastos/pages/inicio_page.dart';
import 'package:app_gastos/pages/ingresos_page.dart';
import 'package:app_gastos/pages/gastos_pages.dart';
import 'package:app_gastos/pages/historial.dart';
//import 'package:AppControlGastos/pages/ona/estadisticas_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Sin opciones: Firebase buscará la configuración en tu google-services.json
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos',
      initialRoute: '/inicio',
      routes: {
        '/inicio': (_) => const InicioPage(),
        '/ingreso': (_) => const PantallaIngresos(),       // de Carolina
        '/gasto': (_)   => const PantallaGastos(),         // de Giuliana
        '/historial': (_) => const PantallaHistorial(),   // de Giuliana
        /*
        '/estadisticas': (_) => const EstadisticasPage(), // de Ona (cuando la suban)
        */
      },
    );
  }
}
