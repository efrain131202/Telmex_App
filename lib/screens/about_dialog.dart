import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class AboutDialogScreen extends StatelessWidget {
  const AboutDialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Acerca de',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              'TelmexEffi',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'TelmexEffi es una aplicación para gestionar archivos de forma sencilla. '
              'Importa, edita y exporta tus datos con facilidad. Ideal para personal '
              'que necesitan manipular datos en hojas de cálculo.',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Versión: 1.0.0',
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(
                  icon: FontAwesomeIcons.squareGithub,
                  color: Colors.black,
                  onPressed: () => _launchURL(
                      'https://github.com/efrain131202/Telmex_App.git'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'El código fuente de esta aplicación se encuentra disponible en GitHub.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Desarrollado con Flutter',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: FaIcon(
        icon,
        color: color,
        size: 30,
      ),
    );
  }

  static Future<void> _launchURL(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      logger.e('Error al lanzar la URL: $e');
    }
  }
}
