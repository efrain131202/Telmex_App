import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class ImportExcelService {
  File? _excelFile;
  List<List<List<dynamic>>>? _excelData;

  Future<void> importExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      _excelFile = File(result.files.single.path!);
      await _loadExcelData();
    }
  }

  Future<void> _loadExcelData() async {
    if (_excelFile != null) {
      try {
        final spreadsheetDecoder =
            SpreadsheetDecoder.decodeBytes(_excelFile!.readAsBytesSync());

        _excelData = [];

        for (var table in spreadsheetDecoder.tables.values) {
          _excelData!.add(table.rows);
        }
      } catch (e) {
        // ignore: avoid_print
        print('Error al cargar datos de Excel: $e');
      }
    }
  }

  List<List<List<dynamic>>>? get excelData => _excelData;
}
