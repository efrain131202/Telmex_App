import 'package:flutter/material.dart';
import 'package:telmexeffi/screens/welcome_screen.dart';
import 'package:telmexeffi/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TelmexEffi',
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
      },
      theme: ThemeData(
        fontFamily: 'MadimiOne',
      ),
    );
  }
}
