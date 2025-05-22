import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<Map<String, dynamic>> getResumen() {
    return _db.collection('usuarios').doc('usuario_demo').snapshots().map(
      (doc) {
        if (!doc.exists) {
          return {
            'ingresos': 0,
            'gastos': 0,
            'saldo': 0,
          };
        }
        final data = doc.data()!;
        final ingresos = data['ingresos'] ?? 0;
        final gastos = data['gastos'] ?? 0;
        final saldo = ingresos - gastos;
        return {
          'ingresos': ingresos,
          'gastos': gastos,
          'saldo': saldo,
        };
      },
    );
  }
  Stream<Map<String, double>> getGastosPorCategoria() {
    return _db
      .collection('usuarios')
      .doc('usuario_demo')
      .collection('gastos')            // ajusta si tu colección se llama distinto
      .snapshots()
      .map((snap) {
        final totals = <String, double>{};
        for (var doc in snap.docs) {
          final cat = doc.data()['categoria'] as String;
          final monto = (doc.data()['monto'] as num).toDouble();
          totals[cat] = (totals[cat] ?? 0) + monto;
        }
        return totals;
      });
  }
}
