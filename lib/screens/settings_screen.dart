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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/image_config.png',
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
