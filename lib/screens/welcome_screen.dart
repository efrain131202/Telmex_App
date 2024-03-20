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
  late Animation<double> _opacityAnimation;
  late Animation<double> _bounceAnimation;

  static const double _logoWidth = 0.36;
  static const double _bottomPadding = 50.0;
  static const String _continueText = 'Presione la pantalla para continuar';
  static const Color _backgroundColor = Color.fromARGB(255, 222, 250, 255);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _bounceAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceOut,
    );

    _animationController.repeat(reverse: true);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * _logoWidth,
                  child: Image.asset(
                    'assets/images/Logo_telmexEffi.png',
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: _bounceAnimation,
                builder: (context, child) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: _bottomPadding * _bounceAnimation.value),
                    child: const Text(
                      _continueText,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
