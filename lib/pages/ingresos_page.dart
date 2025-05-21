import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Control de Gastos',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 34, 255, 41),
          ),
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
  final _tituloController = TextEditingController();
  final _montoController = TextEditingController();
  final _fechaController = TextEditingController();

  int? selectedCategoria;

  final List<String> categorias = [
    'Mensualidad',
    'Ventas',
    'Inversiones',
    'Varios',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AGREGAR INGRESOS',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 20),

                  // TÍTULO
                  Text('TÍTULO', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildInputField(_tituloController),
                  SizedBox(height: 15),

                  // MONTO
                  Text('MONTO', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildInputField(_montoController, prefix: '\$'),
                  SizedBox(height: 15),

                  // FECHA
                  Text('FECHA', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildInputField(_fechaController),
                  SizedBox(height: 15),

                  // CATEGORÍA
                  Text(
                    'CATEGORÍA',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  SizedBox(
                    height: 140,
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(categorias.length, (index) {
                            final isSelected = selectedCategoria == index;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(180, 40),
                                  backgroundColor:
                                      isSelected
                                          ? const Color.fromARGB(
                                            255,
                                            34,
                                            255,
                                            71,
                                          )
                                          : Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedCategoria = index;
                                  });
                                },
                                child: Text(
                                  categorias[index].toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  // BOTÓN AGREGAR
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // lógica para agregar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 14,
                        ),
                      ),
                      child: Text(
                        'AGREGAR',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // BOTÓN CANCELAR
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // lógica para cancelar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 14,
                        ),
                      ),
                      child: Text(
                        'CANCELAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.grey[100],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: ''),
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, {String? prefix}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefix:
            prefix != null
                ? Text(prefix, style: TextStyle(fontWeight: FontWeight.bold))
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      keyboardType:
          prefix == '\$'
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
    );
  }
}
