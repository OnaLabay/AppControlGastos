import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/firebase_options.dart';
import 'pages/inicio_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/estadisticas_page.dart';
import 'pages/gastos_pages.dart';
import 'pages/ingresos_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/historial.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Antes de inicializar Firebase");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Firebase inicializado correctamente");
  await initializeDateFormatting('es', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // La primera pantalla que verá el usuario
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
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
