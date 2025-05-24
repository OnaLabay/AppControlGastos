import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/estadisticas_page.dart';
import 'pages/gastos_pages.dart';
import 'pages/ingresos_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/historial.dart';
import 'pages/inicio_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        /*
        '/': (context) => const LoginPage(),
        '/register_page': (context) => RegisterPage(),
        */
        '/inicio_page': (context) => const InicioPage(),
        '/gastos_pages': (context) => const PantallaGastos(),
        '/ingresos_page': (context) => const PantallaIngresos(),
        '/historial': (context) => const PantallaHistorial(),
        '/estadisticas_page': (context) => const EstadisticasPage(),
      },
    );
  }
}
