import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/firebase_service.dart';
import '../widgets/option_modal.dart';


class InicioPage extends StatelessWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Text(
                'Inicio',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
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
                    // Saldo Total, Ingresos y Gastos
                    StreamBuilder<Map<String, dynamic>>(
                      stream: firebaseService.getResumen(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final datos = snapshot.data ?? {'ingresos': 0.0, 'gastos': 0.0, 'saldo': 0.0};
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Saldo Total
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB26DFF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Saldo Total',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${datos['saldo'].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF82E28D),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text('Ingreso', style: TextStyle(color: Colors.white)),
                                        const SizedBox(height: 6),
                                        Text(
                                          '\$${datos['ingresos'].toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF8888),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text('Gastos', style: TextStyle(color: Colors.white)),
                                        const SizedBox(height: 6),
                                        Text(
                                          '\$${datos['gastos'].toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'Gastos por categoría',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Gráfico de pastel
                    Expanded(
                      child: StreamBuilder<Map<String, double>>(
                        stream: firebaseService.getGastosPorCategoria(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final data = snapshot.data ?? {};
                          final sections = <PieChartSectionData>[];
                          const colorMap = {
                            'alimentos': Colors.green,
                            'educacion': Colors.blue,
                            'transporte': Colors.orange,
                            'vivienda': Colors.purple,
                            'salud': Colors.red,
                            'entretenimiento': Colors.teal,
                            'ropa': Colors.pink,
                            'deudas': Colors.brown,
                            'varios': Colors.grey,
                          };
                          data.forEach((cat, value) {
                            if (value > 0) {
                              sections.add(
                                PieChartSectionData(
                                  value: value,
                                  color: colorMap[cat] ?? Colors.black,
                                  title: value.toInt().toString(),
                                  radius: 60,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                          });
                          if (sections.isEmpty) {
                            return const Center(child: Text('Sin datos para mostrar'));
                          }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) => const OptionModal(),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
              children: const [
                Icon(Icons.home, size: 30),
                Icon(Icons.bar_chart, size: 30),
                Icon(Icons.menu, size: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
