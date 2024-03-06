import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeInAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Método para solicitar permiso de almacenamiento
  Future<void> _requestStoragePermission() async {
    final status = await Permission.storage
        .request(); // Solicita el permiso de almacenamiento
    if (status.isGranted) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context,
          '/home'); // Navega a la siguiente pantalla si el permiso es concedido
    } else {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Permiso necesario',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'Para continuar, necesitamos acceso al almacenamiento del dispositivo.',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/textura.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Telmex_logo.png',
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    const SizedBox(height: 100),
                    ElevatedButton(
                      onPressed: () {
                        _requestStoragePermission(); // Llama al método para solicitar el permiso
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 5,
                      ),
                      child: const Text(
                        'Iniciar',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      '© 2024 Telmex. Todos los derechos reservados.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Permission {
  // ignore: prefer_typing_uninitialized_variables
  static var storage;
}
