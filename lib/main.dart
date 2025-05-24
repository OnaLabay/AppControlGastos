import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/estadisticas_page.dart';
//import 'pages/gastos_page.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'pages/historial_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('es', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login_page',
      routes: {
        '/login_page': (context) => const LoginPage(),
        '/register_page': (context) => RegisterPage(),
        '/estadisticas_page': (context) => const EstadisticasPage(),
        /*'/gastos_page': (context) => const PantallaGastos(),
        '/historial_page': (context) => const PantallaHistorial(),
        'inicio_page' :  (context) => const PantallaInicio()*/
      },
    );
  }
}
