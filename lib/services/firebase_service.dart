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
}
