import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    'Mensualidad',
    'Ventas',
    'Inversiones',
    'Varios',
  ];

  final Map<String, Color> categoriaColors = {
    'Mensualidad': Colors.orange,
    'Ventas': Colors.blue,
    'Inversiones': Colors.green,
    'Varios': Colors.purple,
  };

  void agregarIngreso() async {
    if (_tituloController.text.isNotEmpty &&
        _montoController.text.isNotEmpty &&
        _fechaController.text.isNotEmpty &&
        selectedCategoria != null) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('ingresos')
          .add({
        'titulo': _tituloController.text,
        'monto': double.tryParse(_montoController.text) ?? 0,
        'fecha': _fechaController.text,
        'categoria': selectedCategoria,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingreso agregado')),
      );

      cancelar();
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
              Center(
                child: Text(
                  'Agregar Ingresos',
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

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey[600]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
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
  }
}
