import 'package:flutter/material.dart';

class OptionModal extends StatelessWidget {
  const OptionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Wrap(
        runSpacing: 16,
        children: [
          const Center(
            child: Text('¿Qué deseas registrar?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Aquí luego navegarás a la página 3
            },
            icon: const Icon(Icons.arrow_upward, color: Colors.white),
            label: const Text('Ingreso', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Aquí luego navegarás a la página 4
            },
            icon: const Icon(Icons.arrow_downward, color: Colors.white),
            label: const Text('Gasto', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}
