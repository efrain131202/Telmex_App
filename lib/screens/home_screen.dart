import 'package:flutter/material.dart';
import 'import_excel.dart';
import 'excel_data_viewer.dart';
import 'about_dialog.dart';
import 'exit_dialog.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _importExcelService = ImportExcelService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.black),
            onPressed: () {
              showExitConfirmationDialog(context);
            },
          ),
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
        ],
      ),
      body: ExcelDataViewer(
        excelSheets:
            _importExcelService.excelData, // Cambiar excelData a excelSheets
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
                    colorFilter: ColorFilter.mode(Colors.blue, BlendMode.color),
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
                _importExcelFile,
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

  Future<void> _importExcelFile() async {
    await _importExcelService.importExcelFile();
    setState(() {});
  }
}
