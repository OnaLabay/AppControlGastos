import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tamaño de pantalla para adaptabilidad
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // fondo claro
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo o ícono decorativo
              const Icon(
                Icons.account_balance_wallet,
                size: 72,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 16),

              // Título
              Text(
                'Iniciar sesión',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              // Input de correo
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),

              // Input de contraseña
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),

              // Botón de ingreso
              ElevatedButton(
                onPressed: () {
                  // lógica se agrega después
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 16),

              // Link a registrarse
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/register',
                  ); // ruta que ya definimos
                },
                child: const Text("¿No tenés cuenta? Registrate acá"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
