
/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/estadisticas_page.dart';
import 'pages/gastos_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/historial.dart';




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
        '/': (context) => const LoginPage(),
        '/register_page': (context) => RegisterPage(),
        '/estadisticas_page': (context) => const EstadisticasPage(),
        '/gastos_pages': (context) => const PantallaGastos(),
        '/historial': (context) =>  const PantallaHistorial(),
      },
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/estadisticas_page.dart';
import 'pages/gastos_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/historial.dart';




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
      home: PantallaGastos(), // <-- esto te lleva directo a gastos
    );
  }
}

*/


import 'package:app_gastos/pages/gastos_page.dart';
import 'package:app_gastos/pages/ingresos_page.dart';
import 'package:app_gastos/pages/inicio_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/estadisticas_page.dart';
import 'pages/gastos_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/historial.dart';

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
      title: 'Tu App',
      initialRoute: '/ingresos', 
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/estadisticas': (context) => const EstadisticasPage(),
        '/gastos': (context) => const PantallaGastos(),
        '/historial': (context) => const PantallaHistorial(),
        '/ingresos': (context) => const PantallaIngresos(),
        '/inicio': (context) => const InicioPage(),

      },
    );
  }
}
