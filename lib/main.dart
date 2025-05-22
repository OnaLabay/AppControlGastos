import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/inicio_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);   // Key? y super(key:) requieren Dart ≥2.17

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InicioPage(),
    );
  }
}
