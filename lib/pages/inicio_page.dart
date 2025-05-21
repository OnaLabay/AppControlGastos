// Página de Inicio con diseño fiel a la imagen proporcionada
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/option_modal.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0), // fondo gris clarito
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Inicio',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded( //sizedBox()
              //height: MediaQuery.of(context).size.height * 0.78,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: StreamBuilder<Map<String, dynamic>>(
                  stream: firebaseService.getResumen(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final datos =
                        snapshot.data ??
                        {'ingresos': 0, 'gastos': 0, 'saldo': 0};
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ), // 🔹 NUEVO ESPACIO para bajar el saldo total
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 42,
                              horizontal: 250,
                            ),
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB26DFF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Saldo Total',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                                const SizedBox(height: 6), //20
                                Text(
                                  '\$${datos['saldo']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ), // Baja los boxes más hacia abajo, lejos del "Saldo total".
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //.center, //Centra horizontalmente ambos boxes en la fila.
                            children: [
                              SizedBox(
                                //para que sean mas cuadrados
                                width: 250,
                                height: 200,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF82E28D),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Ingresos',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                      ),
                                      const SizedBox(height: 20), //6;20
                                      Text(
                                        '\$${datos['ingresos']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ), //Agrega más separación;24
                              SizedBox(
                                //para que sean mas cuadrados
                                width: 250,
                                height: 200,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF8888),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Gastos',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                      ),
                                      const SizedBox(height: 20), //6;20
                                      Text(
                                        '\$${datos['gastos']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ), //Agrega más separación; 28.
                          const Center(
                            child: Text(
                              'Gastos por categoría',
                              style: TextStyle(
                                fontSize: 42, //22;32
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50), //16
                          Container(
                            height: 300, // espacio del grafico;160
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(child: Text('Gráfico')),
                          ),
                          const SizedBox(height: 30),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, right: 8),
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                      ),
                                      builder: (context) => const OptionModal(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(0),
                                    elevation: 4,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: const Color(0xFFF0F0F0), // mismo color que fondo
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ), // Mismo margen que la subpantalla blanca
          child: SizedBox(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, size:  30),
                  onPressed: () {
                    // Página actual
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.bar_chart, size:  30),
                  onPressed: () {
                    // Estadísticas
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.menu, size:  30),
                  onPressed: () {
                    // Menú
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
