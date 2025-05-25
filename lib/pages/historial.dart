// 🔥 Pantalla Historial adaptada
import 'package:app_gastos/pages/inicio_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/estadisticas_page.dart';

class PantallaHistorial extends StatelessWidget {
  const PantallaHistorial({super.key});

  // 🔥 Stream combinado de ingresos y gastos ordenado por fecha
  Stream<List<Map<String, dynamic>>> obtenerHistorial() async* {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) yield [];

    final firestore = FirebaseFirestore.instance;

    final ingresosStream = firestore
        .collection('users')
        .doc(uid)
        .collection('ingresos')
        .snapshots();

    final gastosStream =
        firestore.collection('users').doc(uid).collection('gastos').snapshots();

    await for (final ingresosSnapshot in ingresosStream) {
      final gastosSnapshot = await gastosStream.first;

      final ingresosList = ingresosSnapshot.docs.map((doc) => {
            'categoria': doc['categoria'] ?? 'Ingreso',
            'fecha': doc['fecha'] ?? '',
            'monto': doc['monto'] ?? 0.0,
            'tipo': 'Ingreso',
          });

      final gastosList = gastosSnapshot.docs.map((doc) => {
            'categoria': doc['categoria'] ?? 'Gasto',
            'fecha': doc['fecha'] ?? '',
            'monto': doc['monto'] ?? 0.0,
            'tipo': 'Gasto',
          });

      final historial = [...ingresosList, ...gastosList].toList()
        ..sort(
            (a, b) => b['fecha'].toString().compareTo(a['fecha'].toString()));

      yield historial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Historial',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: obtenerHistorial(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final historial = snapshot.data!;

                  if (historial.isEmpty) {
                    return const Center(child: Text('Sin movimientos aún.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: historial.length,
                    itemBuilder: (context, index) {
                      final item = historial[index];
                      final monto = item['monto'] ?? 0.0;

                      // 🔥 Monto formateado (negativo para gasto)
                      final montoFormateado = item['tipo'] == 'Gasto'
                          ? '-\$${monto.toStringAsFixed(2)}'
                          : '\$${monto.toStringAsFixed(2)}';

                      // 🔥 Cambiamos los íconos y colores
                      final esIngreso = item['tipo'] == 'Ingreso';
                      final icono = esIngreso
                          ? Icons.arrow_upward // 🔺 Arriba para ingresos
                          : Icons.arrow_downward; // 🔻 Abajo para gastos
                      final color = esIngreso ? Colors.green : Colors.red;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: esIngreso ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            icono,
                            color: color,
                          ),
                          title: Text(
                            item['categoria'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(item['fecha']),
                          trailing: Text(
                            montoFormateado,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InicioPage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const EstadisticasPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
        ],
      ),
    );
  }
}
