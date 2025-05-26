import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/firebase_service.dart';
import '../widgets/option_modal.dart';
import 'estadisticas_page.dart';
import 'historial.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({Key? key}) : super(key: key);

  void _mostrarDialogoSaldo(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Saldo Total'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Ingrese su saldo inicial',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final monto = double.tryParse(controller.text) ?? 0.0;
              FirebaseService().inicializarSaldo(monto);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Título principal ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Text(
                'Inicio',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            // --- Contenedor principal blanco ---
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Saldo total con gesto para modificar ---
                    StreamBuilder<Map<String, dynamic>>(
                      stream: firebaseService.getResumen(),
                      builder: (context, snapshot) {
                        final data = snapshot.data ??
                            {
                              'saldo': 0.0,
                              'ingresos': 0.0,
                              'gastos': 0.0,
                            };
                        return GestureDetector(
                          onTap: () => _mostrarDialogoSaldo(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 40, horizontal: 20),
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB26DFF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Saldo Total',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '\$${data['saldo'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // --- Ingresos y gastos ---
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF82E28D),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                const Text('Ingreso',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25)),
                                const SizedBox(height: 6),
                                StreamBuilder<Map<String, dynamic>>(
                                  stream: firebaseService.getResumen(),
                                  builder: (context, snapshot) {
                                    final ingresos =
                                        snapshot.data?['ingresos'] ?? 0.0;
                                    return Text(
                                      '\$${ingresos.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF8888),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                const Text('Gastos',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25)),
                                const SizedBox(height: 6),
                                StreamBuilder<Map<String, dynamic>>(
                                  stream: firebaseService.getResumen(),
                                  builder: (context, snapshot) {
                                    final gastos =
                                        snapshot.data?['gastos'] ?? 0.0;
                                    return Text(
                                      '\$${gastos.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // --- Texto Gastos por categoría ---
                    const Center(
                      child: Text(
                        'Gastos por categoría',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // --- Gráfico de torta (PieChart) ---
                    Expanded(
                      child: StreamBuilder<Map<String, double>>(
                        stream: firebaseService.getGastosPorCategoria(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final data = snapshot.data ?? {};
                          if (data.isEmpty) {
                            return const Center(
                                child: Text('Sin datos para mostrar'));
                          }
                          final sections = data.entries.map((entry) {
                            const colorMap = {
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
                            return PieChartSectionData(
                              value: entry.value,
                              color: colorMap[entry.key] ?? Colors.black,
                              title: entry.value.toInt().toString(),
                              radius: 60,
                              titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            );
                          }).toList();

                          return PieChart(
                            PieChartData(
                              sections: sections,
                              centerSpaceRadius: 30,
                              sectionsSpace: 2,
                              borderData: FlBorderData(show: false),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // --- Botón flotante para opciones ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => const OptionModal(),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // --- Barra inferior adaptada con iconos y navegación ---
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: const Color(0xFFF0F0F0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, size: 30),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/inicio'),
                ),
                IconButton(
                  icon: const Icon(Icons.bar_chart, size: 30),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/estadisticas'),
                ),
                IconButton(
                  icon: const Icon(Icons.menu, size: 30),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/historial'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
