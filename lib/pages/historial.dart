import 'package:app_gastos/pages/inicio_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/ingresos_page.dart'; // Importa IngresosPage
import '../pages/estadisticas_page.dart'; // Importa EstadisticasPage
import '../pages/historial.dart'; // Importa Historial (sí mismo)
import '../pages/inicio_page.dart';

class PantallaHistorial extends StatelessWidget {
  const PantallaHistorial({super.key});

  Stream<List<Map<String, dynamic>>> obtenerHistorial() async* {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) yield [];

    final firestore = FirebaseFirestore.instance;

    final ingresosStream = firestore
        .collection('usuarios')
        .doc(uid)
        .collection('ingresos')
        .snapshots();

    final gastosStream = firestore
        .collection('usuarios')
        .doc(uid)
        .collection('gastos')
        .snapshots();

    await for (final ingresos in ingresosStream) {
      final gastos = await gastosStream.first;

      final ingresosList = ingresos.docs.map((doc) => {
            'categoria': doc['categoria'] ?? 'Ingreso',
            'fecha': doc['fecha'] ?? '',
            'monto': doc['monto'] ?? 0.0,
            'tipo': 'Ingreso',
          });

      final gastosList = gastos.docs.map((doc) => {
            'categoria': doc['categoria'] ?? 'Gasto',
            'fecha': doc['fecha'] ?? '',
            'monto': doc['monto'] ?? 0.0,
            'tipo': 'Gasto',
          });

      final historial = [...ingresosList, ...gastosList].toList()
        ..sort((a, b) => b['fecha'].toString().compareTo(a['fecha'].toString()));

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
                      final montoFormateado = item["monto"]
                          .toString()
                          .replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (match) => '${match[1]}.');

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: item["tipo"] == "Gasto"
                              ? Colors.red[50]
                              : Colors.green[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            item["tipo"] == "Gasto"
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: item["tipo"] == "Gasto"
                                ? Colors.red
                                : Colors.green,
                          ),
                          title: Text(item["categoria"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(item["fecha"]),
                          trailing: Text(
                            '\$${montoFormateado}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
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
        currentIndex: 2, // Marcamos el historial como el actual
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
          } else if (index == 2) {
            // Ya estamos en el historial
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