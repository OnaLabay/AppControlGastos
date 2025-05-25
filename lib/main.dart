import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Tus páginas
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/inicio_page.dart';
import 'pages/gastos_pages.dart';
import 'pages/ingresos_page.dart';
import 'pages/historial.dart';
import 'pages/estadisticas_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // La primera pantalla que verá el usuario
      home: const LoginPage(),    
      routes: {
        '/register': (_) => const RegisterPage(),
        '/inicio': (_) => const InicioPage(),
        '/gastos': (_) => const PantallaGastos(),
        '/ingresos': (_) => const PantallaIngresos(),
        '/historial': (_) => const PantallaHistorial(),
        '/estadisticas': (_) => const EstadisticasPage(),
      },
      theme: ThemeData(useMaterial3: true),
    );
  }
}
