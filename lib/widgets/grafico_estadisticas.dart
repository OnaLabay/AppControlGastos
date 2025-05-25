import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'bar_chart_gastos.dart';

class EstadisticasGrafico extends StatelessWidget {
  final String mesSeleccionado; // Ej: "Mayo 2025"

  const EstadisticasGrafico({super.key, required this.mesSeleccionado});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text('No se pudo obtener el usuario.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('gastos')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final docs = snapshot.data!.docs;
        final Map<String, double> gastosPorDia = {};

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = data['timestamp'] as Timestamp?;
          final monto = (data['monto'] ?? 0).toDouble();

          if (timestamp != null) {
            final fecha = timestamp.toDate();
            final mes = DateFormat.MMMM('es').format(fecha);
            final anio = fecha.year.toString();
            final mesAnio = '$mes $anio'; // Ej: "Mayo 2025"

            if (mesAnio.toLowerCase() == mesSeleccionado.toLowerCase()) {
              final dia = DateFormat.d().format(fecha);
              gastosPorDia[dia] = (gastosPorDia[dia] ?? 0) + monto;
            }
          }
        }

        return BarChartGastos(gastosPorDia: gastosPorDia);
      },
    );
  }
}
