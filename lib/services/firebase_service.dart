import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //final String _uid = 'usuario_demo';

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
         final data = doc.data() ?? {};
        final ingresos = (data['ingresos'] as num?)?.toDouble() ?? 0.0;
        final gastos   = (data['gastos']   as num?)?.toDouble() ?? 0.0;
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
  Future<void> addIngreso(double monto) {
    return _db
      .collection('usuarios')
      .doc('usuario_demo')
      .update({
        'ingresos': FieldValue.increment(monto)
      });
  }
  Future<void> addGasto(double monto, String categoria) async {
    final userDoc = _db.collection('usuarios').doc('usuario_demo');
    final batch = _db.batch();

    batch.update(userDoc, {
      'gastos': FieldValue.increment(monto)
    });

    final newGasto = userDoc.collection('gastos').doc();
    batch.set(newGasto, {
      'monto'     : monto,
      'categoria' : categoria,
      'fecha'     : FieldValue.serverTimestamp(),
    });

    return batch.commit();
  }
}
