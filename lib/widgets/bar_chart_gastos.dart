import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartGastos extends StatelessWidget {
  final Map<String, double> gastosPorDia;

  const BarChartGastos({super.key, required this.gastosPorDia});

  @override
  Widget build(BuildContext context) {
    final diasOrdenados = gastosPorDia.keys.toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    final gastos = diasOrdenados.map((dia) => gastosPorDia[dia] ?? 0).toList();

    return SizedBox(
      height: 300,
      child: gastos.isEmpty
          ? const Center(child: Text('Sin datos para mostrar'))
          : BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: gastos.reduce((a, b) => a > b ? a : b) + 50,
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < diasOrdenados.length) {
                          return Text(diasOrdenados[index]);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(diasOrdenados.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: gastos[index],
                        color: Colors.deepPurple.withOpacity(0.7),
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
    );
  }
}
