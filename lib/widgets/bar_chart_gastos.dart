import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Este widget muestra el gráfico de barras con los datos de gastos agrupados por mes
class BarChartGastos extends StatelessWidget {
  final Map<String, double> gastosPorMes;

  const BarChartGastos({super.key, required this.gastosPorMes});

  @override
  Widget build(BuildContext context) {
    // Orden de los meses (para mantener el orden en el gráfico)
    final mesesOrdenados = [
      'Ene',
      'Febr',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sept',
      'Oct',
      'Nov',
      'Dic',
    ];

    // Creamos una lista con los montos de gastos por mes, respetando el orden
    final gastos = mesesOrdenados.map((mes) => gastosPorMes[mes] ?? 0).toList();

    return SizedBox(
      height: 300, // Altura del gráfico
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround, // Espaciado entre barras
          maxY:
              gastos.reduce((a, b) => a > b ? a : b) +
              50, // Altura máxima del eje Y
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true), // Eje Y
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, // Eje X (meses)
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < mesesOrdenados.length) {
                    return Text(mesesOrdenados[index]);
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          barGroups: List.generate(mesesOrdenados.length, (index) {
            // Por cada mes, generamos un grupo de barra con su valor correspondiente
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: gastos[index], // Altura de la barra
                  color: Colors.deepPurple.withOpacity(
                    0.7,
                  ), // Color de la barra
                  width: 18, // Ancho
                  borderRadius: BorderRadius.circular(4), // Bordes redondeados
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
