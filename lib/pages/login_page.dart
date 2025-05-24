import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importamos Firebase Auth
import 'register_page.dart';
import 'estadisticas_page.dart';

// StatefulWidget porque vamos a manejar estado (errores, inputs, etc.)
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para obtener lo que el usuario escribe
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variable para mostrar errores en la pantalla
  String _error = '';

  // Función que intenta iniciar sesión usando Firebase
  Future<void> _login() async {
    try {
      // Firebase intenta iniciar sesión con los datos ingresados
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(), // Elimina espacios al inicio/final
        password: _passwordController.text.trim(),
      );

      // Si se loguea correctamente, va a la pantalla de inicio (ajustá '/home' si usás otra)
      Navigator.pushReplacementNamed(
        context,
        '/inicio_page',
      ); //ACA VA LA PANTALA DE LA VALE
    } on FirebaseAuthException catch (e) {
      // Si falla el login, mostramos el error devuelto por Firebase
      setState(() {
        _error = e.message ?? 'Error desconocido';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Fondo claro
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '¡BIENVENIDO/A!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Título de la pantalla
              Text(
                'Iniciar sesión',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 100),

              // Campo de texto para email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de texto para contraseña (oculto)
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),

              // Botón de ingresar
              ElevatedButton(
                onPressed: _login, // Ejecuta la función de login
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              // Si hay error, lo mostramos en texto rojo
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(_error, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 16),

              // Botón para ir a la pantalla de registro
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register_page');
                },
                child: const Text("¿No tenés cuenta? Registrate acá"),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}