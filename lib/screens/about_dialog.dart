import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDialogScreen extends StatelessWidget {
  const AboutDialogScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        actions: const [],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.175,
                child: Image.asset(
                  'assets/images/Telmex_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'TelmexEffi es una aplicación para gestionar archivos Excel de forma sencilla. '
                'Importa, edita y exporta tus datos con facilidad. Ideal para personal '
                'que necesitan manipular datos en hojas de cálculo.',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Versión: 1.0.0',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 20),
              const Text(
                'Desarrollado por Efrain Cruz Lobato',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => _launchURL(
                        'https://instagram.com/efraincruzlobato._.13?igshid=ZDdkNTZiNTM='),
                    child: const FaIcon(
                      FontAwesomeIcons.squareInstagram,
                      color: Colors.pink,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () => _launchURL('https://github.com/efrain131202'),
                    child: const FaIcon(
                      FontAwesomeIcons.squareGithub,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () => _launchURL(
                        'https://www.facebook.com/efrain.cruzlobato.9'),
                    child: const FaIcon(
                      FontAwesomeIcons.squareFacebook,
                      color: Colors.blueAccent,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
