import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:app_gastos/services/firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  String? selectedCategoria;

  final List<String> categorias = [
    'alimentos',
    'educacion',
    'transporte',
    'vivienda',
    'salud',
    'entretenimiento',
    'ropa',
    'deudas',
    'varios',
  ];

  void agregarGasto() {
    if (_tituloController.text.isNotEmpty &&
        _montoController.text.isNotEmpty &&
        _fechaController.text.isNotEmpty &&
        selectedCategoria != null) {
      print('Título: ${_tituloController.text}');
      print('Monto: ${_montoController.text}');
      print('Fecha: ${_fechaController.text}');
      print('Categoría: $selectedCategoria');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gasto agregado')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Completá todos los campos')),
      );
    }
  }

  void cancelar() {
    _tituloController.clear();
    _montoController.clear();
    _fechaController.clear();
    setState(() {
      selectedCategoria = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agregar gastos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              Text('Título'),
              TextField(
                controller: _tituloController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 12),

              Text('Monto'),
              TextField(
                controller: _montoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 12),

              Text('Fecha'),
              TextField(
                controller: _fechaController,
                decoration: InputDecoration(
                  hintText: 'dd/mm/aaaa',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 12),

              Text('Categoría'),
              Expanded(
                child: ListView(
                  children: categorias.map((categoria) {
                    final isSelected = selectedCategoria == categoria;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedCategoria = categoria;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.black : Colors.white,
                          foregroundColor: isSelected ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide(color: Colors.black),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(categoria),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 10),
              ElevatedButton(
                onPressed: agregarGasto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Agregar'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: cancelar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '',
          ),
        ],
      ),
    );
  }
}
