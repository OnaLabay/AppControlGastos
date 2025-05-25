import 'package:flutter/material.dart';
import '../widgets/grafico_estadisticas.dart';
import 'inicio_page.dart';
import 'historial.dart';

class EstadisticasPage extends StatefulWidget {
  const EstadisticasPage({super.key});

  @override
  State<EstadisticasPage> createState() => _EstadisticasPageState();
}

class _EstadisticasPageState extends State<EstadisticasPage> {
  // Generar lista dinámica de últimos 12 meses
  List<String> obtenerUltimos12Meses() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      final fecha = DateTime(now.year, now.month - index, 1);
      final mes = fecha.month;
      final anio = fecha.year;
      final nombreMes = _nombreMes(mes);
      return '$nombreMes $anio';
    });
  }

  String _nombreMes(int mes) {
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return meses[mes - 1];
  }

  late String mesSeleccionado; // Selección inicial

  @override
  void initState() {
    super.initState();
    mesSeleccionado = obtenerUltimos12Meses().first; // Mes actual por defecto
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/inicio');
    } else if (index == 1) {
      // ya estamos aquí
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/historial');
    }
  }

  @override
  Widget build(BuildContext context) {
    final meses = obtenerUltimos12Meses(); // Opciones del dropdown

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Estadísticas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gastos por día del mes',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      DropdownButton<String>(
                        value: mesSeleccionado,
                        items: meses
                            .map((mes) =>
                                DropdownMenuItem(value: mes, child: Text(mes)))
                            .toList(),
                        onChanged: (nuevoMes) {
                          if (nuevoMes != null) {
                            setState(() {
                              mesSeleccionado = nuevoMes;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                          child: EstadisticasGrafico(
                              mesSeleccionado: mesSeleccionado)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFFEFEFEF),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
        ],
      ),
    );
  }
}
