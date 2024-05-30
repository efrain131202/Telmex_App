import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:logger/logger.dart';

class ImportExcelService {
  final _logger = Logger();
  File? _excelFile;
  List<List<List<dynamic>>>? _excelData;
  List<String>? _sheetNames;

  Future<void> importExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result == null) {
        _logger.w('No se seleccionó ningún archivo.');
        return;
      }

      String? filePath = result.files.single.path;

      if (filePath == null) {
        _logger.w('La ruta del archivo es nula.');
        return;
      }

      _excelFile = File(filePath);
      _logger.i('Archivo seleccionado: $filePath');

      await _loadExcelData();
    } catch (e, stackTrace) {
      _logger.e('Error al importar el archivo de Excel',
          error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _loadExcelData() async {
    if (_excelFile == null) {
      _logger.w('El archivo de Excel no está definido.');
      return;
    }

    try {
      final bytes = await _excelFile!.readAsBytes();
      final spreadsheetDecoder = SpreadsheetDecoder.decodeBytes(bytes);

      _excelData = [];
      _sheetNames = [];

      for (var table in spreadsheetDecoder.tables.values) {
        _excelData!.add(table.rows);
        _sheetNames!.add(table.name);
        _logger.i('Hoja cargada: ${table.name}');
      }
    } catch (e, stackTrace) {
      _logger.e('Error al cargar datos de Excel',
          error: e, stackTrace: stackTrace);
    }
  }

  List<List<List<dynamic>>>? get excelData => _excelData;
  List<String>? get sheetNames => _sheetNames;
}
