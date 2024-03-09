import 'package:flutter/material.dart';
import 'package:telmexinsumo/screens/about_dialog.dart';
import 'exit_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.notes_rounded, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.black,
            ),
            color: Colors.red,
            onPressed: () {
              showExitConfirmationDialog(context);
            },
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            backgroundColor: Colors.black,
            backgroundImage: AssetImage(
              'assets/images/Icono_TelmexEffi.png',
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fondo_drawer.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(
                'TelmexEffi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildDrawerIconButton(
              Icons.arrow_circle_up_rounded,
              'Importar',
              () {},
            ),
            _buildDrawerIconButton(
              Icons.arrow_circle_down_rounded,
              'Exportar',
              () {},
            ),
            _buildDrawerIconButton(
              Icons.edit_note_rounded,
              'Editar',
              () {},
            ),
            _buildDrawerIconButton(
              Icons.save_rounded,
              'Guardar',
              () {},
            ),
            _buildDrawerIconButton(
              Icons.info_rounded,
              'Acerca de',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutDialogScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerIconButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onPressed,
    );
  }
}
