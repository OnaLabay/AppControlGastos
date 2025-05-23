import 'package:flutter/material.dart';

class EstadisticasPage extends StatelessWidget {
  const EstadisticasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color de fondo de toda la pantalla (gris claro)
      backgroundColor: const Color(0xFFEFEFEF),

      // SafeArea evita que el contenido quede debajo de la barra de estado del celular
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ), // Espaciado interno de la pantalla
          child: Column(
            children: [
              // Título principal "Estadísticas"
              const Text(
                'Estadísticas',
                style: TextStyle(
                  fontSize: 24, // Tamaño del texto
                  fontWeight: FontWeight.bold, // Negrita
                  decorationThickness: 2, // Grosor de la línea
                ),
              ),

              const SizedBox(
                height: 16,
              ), // Espacio entre el título y el contenedor blanco
              // Contenedor blanco principal donde van los datos
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(
                    16,
                  ), // Espacio interno del contenedor
                  decoration: BoxDecoration(
                    color: Colors.white, // Fondo blanco
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // Bordes redondeados
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinear a la izquierda
                    children: [
                      // Subtítulo "Gastos Mensuales"
                      const Text(
                        'Gastos Mensuales',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ), // Espacio entre título y dropdown
                      // Dropdown para seleccionar "Fecha" (más filtros pueden agregarse después)
                      DropdownButton<String>(
                        value: 'Fecha', // Valor seleccionado por defecto
                        items: const [
                          DropdownMenuItem(
                            value: 'Fecha',
                            child: Text('Fecha'),
                          ),
                        ],
                        onChanged: (value) {
                          // En esta función se manejará el cambio de selección
                        },
                      ),

                      const SizedBox(height: 24), // Espacio antes del gráfico
                      // Placeholder del gráfico: esto se reemplazará por el gráfico real en el próximo paso
                      Expanded(
                        child: Center(
                          child: Text(
                            '📊 Aquí irá el gráfico de barras',
                            style: TextStyle(color: Colors.grey),
                          ),
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

      // Barra inferior de navegación con tres íconos
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Índice actual (el segundo ícono: gráfico)
        backgroundColor: Color(0xFFEFEFEF),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Primer ícono: casa
            label: '', // Sin texto debajo
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), // Segundo ícono: estadísticas
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu), // Tercer ícono: menú
            label: '',
          ),
        ],
      ),
    );
  }
}