import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final DocumentReference<Map<String, dynamic>> _doc = FirebaseFirestore.instance.collection('usuarios').doc('usuario_demo');
  
  Stream<Map<String, dynamic>> getResumen() {
    return _doc.snapshots().map((snap) {
      final data = snap.data()!;
      return {
        'saldo':    (data['saldo']    as num).toDouble(),
        'ingresos': (data['ingresos'] as num).toDouble(),
        'gastos':   (data['gastos']   as num).toDouble(),
      };
    });
  }
  /// Inicializa (o reinicia) el saldo, dejando ingresos y gastos a 0
  Future<void> inicializarSaldo(double monto) {
    return _doc.set({
      'saldo':    monto,
      'ingresos': 0.0,
      'gastos':   0.0,
    }, SetOptions(merge: true));
  }

  /// Registra un ingreso: incrementa 'ingresos' y 'saldo'
  Future<void> registrarIngreso(double monto) {
    return _doc.update({
      'ingresos': FieldValue.increment(monto),
      'saldo': FieldValue.increment(monto),
    });
  }

  /// Registra un gasto: incrementa 'gastos' y decrementa 'saldo'
  Future<void> registrarGasto(double monto) {
    return _doc.update({
      'gastos': FieldValue.increment(monto),
      'saldo': FieldValue.increment(-monto),
    });
  }

  Stream<Map<String, double>> getGastosPorCategoria() {
    return _db
        .collection('usuarios')
        .doc('usuario_demo')
        .collection('gastos') // ajusta si tu colección se llama distinto
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
