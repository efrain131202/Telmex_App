import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _storagePermissionGranted = false;
  bool _cloudStorageEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final storagePermission = await Permission.storage.request();

    setState(() {
      _storagePermissionGranted = storagePermission.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Permisos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SwitchListTile(
              title: const Text('Acceso a archivos'),
              value: _storagePermissionGranted,
              onChanged: (value) async {
                final status = await Permission.storage.request();
                setState(() {
                  _storagePermissionGranted = status.isGranted;
                });
              },
              activeColor: Colors.blue,
              inactiveTrackColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Almacenamiento en la nube',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SwitchListTile(
              title: const Text('Guardar archivos en la nube'),
              value: _cloudStorageEnabled,
              onChanged: (value) {
                setState(() {
                  _cloudStorageEnabled = value;
                });
                if (value) {
                  _showCloudStorageDialog(context);
                }
              },
              activeColor: Colors.blue,
              inactiveTrackColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Ayuda',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            ListTile(
              title: const Text('Contactar soporte'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showHelpDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCloudStorageDialog(BuildContext context) {
    // Muestra un cuadro de diálogo o una pantalla para seleccionar archivos
    // y cargarlos a la nube utilizando la API del servicio de almacenamiento
  }

  void _showHelpDialog(BuildContext context) {
    // Muestra un cuadro de diálogo o una pantalla con información de ayuda,
    // preguntas frecuentes o un formulario de contacto
  }
}
