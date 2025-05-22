import 'package:flutter/material.dart';
import 'pages/inicio_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
