import 'package:flutter/material.dart';
import 'package:telmexinsumo/screens/about_dialog.dart';
import 'exit_dialog.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.notes_rounded, color: Colors.black),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            title: const Text(
              'TelmexEffi',
              style: TextStyle(color: Colors.blue),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.black),
                onPressed: () {
                  showExitConfirmationDialog(context);
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.settings_rounded, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      drawer: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0) {
            _scaffoldKey.currentState?.openDrawer();
          }
        },
        child: Drawer(
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
                      builder: (context) => const AboutDialogScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
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
