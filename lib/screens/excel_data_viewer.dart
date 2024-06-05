import 'package:flutter/material.dart';
import 'custom_error_screen.dart';
import 'message_widget.dart';
import 'package:logger/logger.dart';

class ExcelDataViewer extends StatefulWidget {
  final List<List<List<dynamic>>>? excelSheets;

  const ExcelDataViewer({super.key, required this.excelSheets});

  @override
  State<ExcelDataViewer> createState() => _ExcelDataViewerState();
}

class _ExcelDataViewerState extends State<ExcelDataViewer>
    with SingleTickerProviderStateMixin {
  int _selectedSheetIndex = 0;
  int? _selectedRowIndex;
  int? _fixedRowIndex;
  final double _scale = 1.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _searchTerm = '';
  List<String> _suggestions = [];
  bool _showSuggestions = false;
  final logger = Logger();
  final List<int> _selectedColumns = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateSuggestions(String value) {
    setState(() {
      _suggestions = _generateSuggestions(value);
      _showSuggestions = _suggestions.isNotEmpty;
    });
  }

  List<String> _generateSuggestions(String query) {
    List<String> suggestions = [];
    if (widget.excelSheets != null &&
        _selectedSheetIndex < widget.excelSheets!.length) {
      for (var row in widget.excelSheets![_selectedSheetIndex]) {
        for (var cell in row) {
          if (cell != null &&
              cell.toString().toLowerCase().contains(query.toLowerCase())) {
            suggestions.add(cell.toString());
          }
        }
      }
    }
    return suggestions.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>>? currentSheet =
        widget.excelSheets?[_selectedSheetIndex];
    try {
      if (currentSheet != null) {
        return Column(
          children: [
            _buildToolbar(currentSheet),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Transform.scale(
                    scale: _scale,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: _buildTable(context, currentSheet),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Center(
          child: MessageWidget(animation: _animation),
        );
      }
    } catch (e) {
      logger.e("Error: $e");
      return const CustomErrorScreen();
    }
  }

  Widget _buildToolbar(List<List<dynamic>> currentSheet) {
    List<dynamic> firstColumnValues =
        currentSheet.map((row) => row[0] ?? '').toList();

    List<String> columnHeaders = [];
    if (_fixedRowIndex != null && _fixedRowIndex! < currentSheet.length) {
      columnHeaders =
          currentSheet[_fixedRowIndex!].map((cell) => cell.toString()).toList();
    } else if (currentSheet.isNotEmpty) {
      columnHeaders = currentSheet[0].map((cell) => cell.toString()).toList();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<int>(
                value: _selectedSheetIndex,
                items: List.generate(
                  widget.excelSheets!.length,
                  (index) => DropdownMenuItem(
                    value: index,
                    child: Text(
                      widget.excelSheets![index][0][0] != null
                          ? widget.excelSheets![index][0][0].toString().length >
                                  10
                              ? '${widget.excelSheets![index][0][0].toString().substring(0, 10)}...'
                              : widget.excelSheets![index][0][0].toString()
                          : 'Hoja ${index + 1}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedSheetIndex = value!;
                    _selectedRowIndex = null;
                    _fixedRowIndex = null;
                    _selectedColumns.clear();
                  });
                },
              ),
              DropdownButton<int?>(
                value: _selectedRowIndex,
                hint: const Text('Seleccionar fila'),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Todas las filas'),
                  ),
                  for (int index = 0; index < firstColumnValues.length; index++)
                    DropdownMenuItem(
                      value: index,
                      child: Text(
                        firstColumnValues[index].toString().length > 10
                            ? '${firstColumnValues[index].toString().substring(0, 10)}...'
                            : firstColumnValues[index].toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRowIndex = value;
                  });
                },
              ),
              DropdownButton<int?>(
                value: _fixedRowIndex,
                hint: const Text('Seleccionar fila fijada'),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Ninguna fila fijada'),
                  ),
                  for (int index = 0; index < currentSheet.length; index++)
                    DropdownMenuItem(
                      value: index,
                      child: Text(
                        currentSheet[index][0].toString().length > 10
                            ? '${currentSheet[index][0].toString().substring(0, 10)}...'
                            : currentSheet[index][0].toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    _fixedRowIndex = value;
                    _selectedColumns.clear();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Seleccionar columnas"),
              Wrap(
                children: List.generate(columnHeaders.length, (index) {
                  return ChoiceChip(
                    label: Text(columnHeaders[index]),
                    selected: _selectedColumns.contains(index),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedColumns.add(index);
                        } else {
                          _selectedColumns.remove(index);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchTerm = value;
                        _updateSuggestions(value);
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Buscar',
                      hintStyle: const TextStyle(color: Colors.black),
                      suffixIcon: _searchTerm.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.cancel_rounded),
                              onPressed: () {
                                setState(() {
                                  _searchTerm = '';
                                  _showSuggestions = false;
                                });
                              },
                            )
                          : null,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  if (_showSuggestions && _suggestions.isNotEmpty)
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              _suggestions[index],
                              style: const TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              setState(() {
                                _searchTerm = _suggestions[index];
                                _showSuggestions = false;
                              });
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<List<dynamic>> sheet) {
    List<List<dynamic>> filteredRows = [];

    if (_fixedRowIndex != null) {
      filteredRows.add(sheet[_fixedRowIndex!]);
    }

    if (_selectedRowIndex != null) {
      filteredRows.add(sheet[_selectedRowIndex!]);
    } else {
      filteredRows.addAll(sheet.where((row) {
        for (var cell in row) {
          if (cell != null && cell.toString().contains(_searchTerm)) {
            return true;
          }
        }
        return false;
      }).toList());
    }

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder.all(
        color: Colors.blue.shade300,
        style: BorderStyle.solid,
        width: 1,
      ),
      children: [
        for (int rowIndex = 0; rowIndex < filteredRows.length; rowIndex++)
          TableRow(
            decoration: BoxDecoration(
              color: rowIndex == 0 && _fixedRowIndex != null
                  ? Colors.blue
                  : (rowIndex % 2 == 0 ? Colors.grey.shade200 : Colors.white),
              border: Border.all(
                color: Colors.blue.shade300,
              ),
            ),
            children: [
              for (int columnIndex = 0;
                  columnIndex < filteredRows[rowIndex].length;
                  columnIndex++)
                if (_selectedColumns.isEmpty ||
                    _selectedColumns.contains(columnIndex))
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child:
                        _buildReadOnlyCell(filteredRows, rowIndex, columnIndex),
                  ),
            ],
          ),
      ],
    );
  }

  Widget _buildReadOnlyCell(
      List<List<dynamic>> filteredRows, int rowIndex, int columnIndex) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        filteredRows[rowIndex][columnIndex]?.toString() ?? '',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }
}
