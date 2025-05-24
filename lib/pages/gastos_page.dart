import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/login_page.dart';
import '../pages/estadisticas_page.dart';
import '../pages/historial.dart';
import '../pages/ingresos_page.dart';
import '../pages/inicio_page.dart';

class PantallaGastos extends StatefulWidget {
  const PantallaGastos({super.key});

  @override
  State<PantallaGastos> createState() => _PantallaGastosState();
}

class _PantallaGastosState extends State<PantallaGastos> {
  final _tituloController = TextEditingController();
  final _montoController = TextEditingController();
  final _fechaController = TextEditingController();
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

  final Map<String, Color> categoriaColors = {
    'alimentos': Colors.orange,
    'educacion': Colors.blue,
    'transporte': Colors.green,
    'vivienda': Colors.brown,
    'salud': Colors.red,
    'entretenimiento': Colors.purple,
    'ropa': Colors.pink,
    'deudas': Colors.teal,
    'varios': Colors.grey,
  };

  void agregarGasto() async {
    if (_tituloController.text.isNotEmpty &&
        _montoController.text.isNotEmpty &&
        _fechaController.text.isNotEmpty &&
        selectedCategoria != null) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('gastos')
          .add({
        'titulo': _tituloController.text,
        'monto': double.tryParse(_montoController.text) ?? 0,
        'fecha': _fechaController.text,
        'categoria': selectedCategoria,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gasto agregado')),
      );

      cancelar(); // Limpia los campos

      // Navegar a la pantalla de inicio después de agregar el gasto
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  InicioPage()),
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
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight - 60, // Altura mínima menos la altura del BottomNavigationBar
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Agregar gastos',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _tituloController,
                        decoration: const InputDecoration(labelText: 'Título'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _montoController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Monto', prefixText: '\$ '),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _fechaController,
                        decoration: const InputDecoration(labelText: 'Fecha (dd/mm/aaaa)'),
                      ),
                      const SizedBox(height: 16),
                      const Text('Categoría'),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 240,
                        child: SingleChildScrollView(
                          child: Column(
                            children: categorias.map((categoria) {
                              final isSelected = selectedCategoria == categoria;
                              final color = categoriaColors[categoria]!;
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedCategoria = categoria;
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: isSelected ? color : Colors.white,
                                    foregroundColor: isSelected ? Colors.white : color,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    side: BorderSide(color: color),
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  ),
                                  child: Center(child: Text(categoria)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: agregarGasto,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Agregar'),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: cancelar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: 1, // Estás en la sección de "gastos"
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InicioPage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const EstadisticasPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PantallaHistorial()),
            );
          }
        },
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