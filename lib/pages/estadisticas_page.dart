import 'package:flutter/material.dart';
import '../widgets/grafico_estadisticas.dart'; // Ruta al widget del gráfico
// Importar las demás páginas para la navegación
//import 'inicio_page.dart';
//import 'menu_page.dart';

/// Pantalla principal de estadísticas con filtro por mes y navegación inferior
class EstadisticasPage extends StatefulWidget {
  const EstadisticasPage({super.key});

  @override
  State<EstadisticasPage> createState() => _EstadisticasPageState();
}

class _EstadisticasPageState extends State<EstadisticasPage> {
  // Lista de meses para el filtro
  final List<String> meses = [
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
    'Diciembre',
  ];
  String mesSeleccionado = 'Mayo'; // Mes por defecto

  // Función para manejar la navegación al tocar un ícono
  void _onItemTapped(int index) {
    if (index == 0) {
      // Si toca el ícono de Inicio, navegamos a InicioPage
      Navigator.pushReplacementNamed(context, '/inicio_page');
    } else if (index == 1) {
      // Si toca el ícono de Estadísticas, ya estamos aquí, no hacemos nada
    } else if (index == 2) {
      // Si toca el ícono de Historial, navegamos a Historial
      Navigator.pushReplacementNamed(context, '/historial_page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF), // Fondo gris claro
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Espacio alrededor
          child: Column(
            children: [
              // Título principal
              const Text(
                'Estadísticas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decorationThickness: 2,
                ),
              ),
              const SizedBox(height: 16), // Espacio después del título
              // Contenedor blanco con el contenido
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtítulo
                      const Text(
                        'Gastos Mensuales',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Dropdown para seleccionar mes
                      DropdownButton<String>(
                        value: mesSeleccionado,
                        items:
                            meses.map((mes) {
                              return DropdownMenuItem(
                                value: mes,
                                child: Text(mes),
                              );
                            }).toList(),
                        onChanged: (nuevoMes) {
                          if (nuevoMes != null) {
                            setState(() {
                              mesSeleccionado = nuevoMes;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 24), // Espacio antes del gráfico
                      // Gráfico de gastos filtrado por mes
                      Expanded(
                        child: EstadisticasGrafico(
                          mesSeleccionado: mesSeleccionado,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Barra de navegación inferior con navegación simple entre pantallas
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Página actual: Estadísticas (índice 1)
        onTap: _onItemTapped, // Maneja los toques en los íconos
        backgroundColor: const Color(0xFFEFEFEF),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ), // Índice 0
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '',
          ), // Índice 1
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '',
          ), // Índice 2
        ],
      ),
    );
  }
}
