import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:telmexeffi/screens/about_dialog.dart';
import 'package:telmexeffi/screens/exit_dialog.dart';
import 'import_excel.dart';
import 'excel_data_viewer.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _importExcelService = ImportExcelService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutDialogScreen(),
              ),
            );
          },
          child: const Text(
            'TelmexEffi',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded, color: Colors.black),
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 0.2,
            thickness: 0.2,
            color: Colors.grey,
          ),
        ),
      ),
      body: Stack(
        children: [
          ExcelDataViewer(
            excelSheets: _importExcelService.excelData,
          ),
          if (_isLoading)
            const Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _importExcelFile,
        child: const Icon(Icons.file_upload_rounded, color: Colors.white),
      ),
    );
  }

  Future<void> _importExcelFile() async {
    setState(() {
      _isLoading = true;
    });

    await _importExcelService.importExcelFile();

    setState(() {
      _isLoading = false;
    });
  }
}
