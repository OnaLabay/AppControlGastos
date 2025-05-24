import 'package:app_gastos/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/inicio_page.dart';
import '../pages/estadisticas_page.dart';
import '../pages/historial.dart';

class PantallaIngresos extends StatefulWidget {
  const PantallaIngresos({super.key});

  @override
  State<PantallaIngresos> createState() => _PantallaIngresosState();
}

class _PantallaIngresosState extends State<PantallaIngresos> {
  final _tituloController = TextEditingController();
  final _montoController = TextEditingController();
  final _fechaController = TextEditingController();
  String? selectedCategoria;

  final List<String> categorias = [
    'sueldo',
    'ventas',
    'regalos',
    'intereses',
    'otros',
  ];

  final Map<String, Color> categoriaColors = {
    'sueldo': Colors.green,
    'ventas': Colors.blue,
    'regalos': Colors.purple,
    'intereses': Colors.orange,
    'otros': Colors.grey,
  };

  void agregarIngreso() async {
    if (_tituloController.text.isNotEmpty &&
        _montoController.text.isNotEmpty &&
        _fechaController.text.isNotEmpty &&
        selectedCategoria != null) {
      final monto = double.tryParse(_montoController.text) ?? 0;
      if (monto <= 0) return;

      await FirebaseService().registrarIngreso(monto, selectedCategoria!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingreso agregado')),
      );

      cancelar();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InicioPage()),
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
                  minHeight: viewportConstraints.maxHeight - 60,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Agregar Ingresos',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
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
                        decoration: const InputDecoration(
                            labelText: 'Monto', prefixText: '\$ '),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _fechaController,
                        decoration: const InputDecoration(
                            labelText: 'Fecha (dd/mm/aaaa)'),
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
                                    backgroundColor:
                                        isSelected ? color : Colors.white,
                                    foregroundColor:
                                        isSelected ? Colors.white : color,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    side: BorderSide(color: color),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
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
                            onPressed: agregarIngreso,
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
        currentIndex: 1,
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
              MaterialPageRoute(
                  builder: (context) => const PantallaHistorial()),
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
