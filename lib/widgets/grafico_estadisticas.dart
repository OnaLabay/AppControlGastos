import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'bar_chart_gastos.dart'; // Widget del gráfico en sí

/// Este widget recibe el mes seleccionado y muestra el gráfico de gastos
class EstadisticasGrafico extends StatelessWidget {
  final String mesSeleccionado;

  const EstadisticasGrafico({super.key, required this.mesSeleccionado});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ID del usuario autenticado
    final uid = FirebaseAuth.instance.currentUser?.uid;

    // Si no hay usuario autenticado, mostramos un error
    if (uid == null) {
      return const Center(child: Text('No se pudo obtener el usuario.'));
    }

    // Escuchamos en tiempo real los gastos desde Firestore
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('gastos')
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(); // Muestra un loader si aún no hay datos
        }

        final docs = snapshot.data!.docs;
        final Map<String, double> gastosPorDia = {}; // Agrupamos por día

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = data['timestamp'] as Timestamp?;
          final monto = (data['monto'] ?? 0).toDouble();

          if (timestamp != null) {
            final fecha = timestamp.toDate();
            final mesActual = DateFormat.MMMM('es').format(fecha); // Ej: "mayo"

            // Solo sumamos si el mes coincide con el seleccionado
            if (mesActual.toLowerCase() == mesSeleccionado.toLowerCase()) {
              final dia = DateFormat.d().format(fecha); // Ej: "1", "2", "3"
              gastosPorDia[dia] = (gastosPorDia[dia] ?? 0) + monto;
            }
          }
        }

        // Mostramos el gráfico pasando los datos filtrados
        return BarChartGastos(gastosPorMes: gastosPorDia);
      },
    );
  }
}
