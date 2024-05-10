import 'package:flutter/material.dart';
import 'custom_error_screen.dart';
import 'message_widget.dart';
import 'package:logger/logger.dart';
import 'cell_options.dart';

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
  final double _scale = 1.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _searchTerm = '';
  List<String> _suggestions = [];
  bool _showSuggestions = false;
  bool _editMode = false;
  final logger = Logger();

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
              Row(
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.black,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.save_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ClipOval(
                    child: Material(
                      color: Colors.blue,
                      child: IconButton(
                        onPressed: () {
                          // Lógica para exportar
                        },
                        icon: const Icon(
                          Icons.file_download_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ClipOval(
                    child: Material(
                      color: _editMode ? Colors.red : Colors.blue,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _editMode = !_editMode;
                          });
                        },
                        icon: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.search_rounded, color: Colors.black),
                ),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Buscar...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchTerm = value;
                      });
                      _updateSuggestions(value);
                    },
                  ),
                ),
                if (_searchTerm.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _searchTerm = '';
                        _showSuggestions = false;
                      });
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (_showSuggestions)
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
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
    );
  }

  Widget _buildTable(BuildContext context, List<List<dynamic>> sheet) {
    List<List<dynamic>> filteredRows = [];

    if (_selectedRowIndex != null) {
      filteredRows.add(sheet[0]);
      filteredRows.add(sheet[_selectedRowIndex!]);
    } else {
      filteredRows.add(sheet[0]);
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
        if (_editMode)
          TableRow(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            children: [
              for (int columnIndex = 0;
                  columnIndex < sheet[0].length;
                  columnIndex++)
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Columna $columnIndex',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (_editMode)
                const TableCell(
                  child: SizedBox.shrink(),
                ),
            ],
          ),
        for (int rowIndex = 0; rowIndex < filteredRows.length; rowIndex++)
          TableRow(
            decoration: BoxDecoration(
              color: rowIndex == 0
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
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: GestureDetector(
                    onLongPress: () {
                      if (_editMode) {
                        _showAddOptions(context, rowIndex, columnIndex);
                      }
                    },
                    child: _editMode
                        ? _buildEditableCell(
                            filteredRows, rowIndex, columnIndex)
                        : _buildReadOnlyCell(
                            filteredRows, rowIndex, columnIndex),
                  ),
                ),
              if (_editMode)
                const TableCell(
                  child: SizedBox.shrink(),
                ),
            ],
          ),
        if (_editMode)
          TableRow(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            children: [
              for (int columnIndex = 0;
                  columnIndex <= sheet[0].length;
                  columnIndex++)
                const TableCell(
                  child: SizedBox.shrink(),
                ),
            ],
          ),
      ],
    );
  }

  void _showAddOptions(BuildContext context, int rowIndex, int columnIndex) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = overlay.localToGlobal(Offset.zero);

    final List<PopupMenuEntry<String>> menuItems = [
      const PopupMenuItem<String>(
        value: 'addRowAbove',
        child: ListTile(
          leading: Icon(Icons.arrow_upward_rounded),
          title: Text('Agregar fila arriba'),
        ),
      ),
      const PopupMenuItem<String>(
        value: 'addRowBelow',
        child: ListTile(
          leading: Icon(Icons.arrow_downward_rounded),
          title: Text('Agregar fila abajo'),
        ),
      ),
      const PopupMenuItem<String>(
        value: 'addColumnLeft',
        child: ListTile(
          leading: Icon(Icons.arrow_back_rounded),
          title: Text('Agregar columna a la izquierda'),
        ),
      ),
      const PopupMenuItem<String>(
        value: 'addColumnRight',
        child: ListTile(
          leading: Icon(Icons.arrow_forward_rounded),
          title: Text('Agregar columna a la derecha'),
        ),
      ),
    ];

    showMenu<String>(
      context: context,
      position:
          RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
      items: menuItems,
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'addRowAbove':
            _addRowAbove(rowIndex);
            break;
          case 'addRowBelow':
            _addRowBelow(rowIndex);
            break;
          case 'addColumnLeft':
            _addColumnLeft(columnIndex);
            break;
          case 'addColumnRight':
            _addColumnRight(columnIndex);
            break;
        }
      }
    });
  }

  void _addRowAbove(int rowIndex) {
    setState(() {
      widget.excelSheets![_selectedSheetIndex].insert(rowIndex,
          List.filled(widget.excelSheets![_selectedSheetIndex][0].length, ''));
    });
  }

  void _addRowBelow(int rowIndex) {
    setState(() {
      widget.excelSheets![_selectedSheetIndex].insert(rowIndex + 1,
          List.filled(widget.excelSheets![_selectedSheetIndex][0].length, ''));
    });
  }

  void _addColumnLeft(int columnIndex) {
    setState(() {
      for (int i = 0;
          i < widget.excelSheets![_selectedSheetIndex].length;
          i++) {
        List<dynamic> newRow =
            List.from(widget.excelSheets![_selectedSheetIndex][i]);
        newRow.insert(columnIndex, '');
        widget.excelSheets![_selectedSheetIndex][i] = newRow;
      }
    });
  }

  void _addColumnRight(int columnIndex) {
    setState(() {
      for (int i = 0;
          i < widget.excelSheets![_selectedSheetIndex].length;
          i++) {
        List<dynamic> newRow =
            List.from(widget.excelSheets![_selectedSheetIndex][i]);
        newRow.insert(columnIndex + 1, '');
        widget.excelSheets![_selectedSheetIndex][i] = newRow;
      }
    });
  }

  Widget _buildEditableCell(
      List<List<dynamic>> filteredRows, int rowIndex, int columnIndex) {
    final currentValue = filteredRows[rowIndex][columnIndex]?.toString() ?? '';
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: TextEditingController(text: currentValue),
                  onChanged: (value) {
                    setState(() {
                      filteredRows[rowIndex][columnIndex] = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Editar celda',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      onLongPress: () {
        _showCellOptions(context, rowIndex, columnIndex);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          currentValue,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  void _showCellOptions(BuildContext context, int rowIndex, int columnIndex) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CellOptions(
          onAddRowAbove: _addRowAbove,
          onAddRowBelow: _addRowBelow,
          onAddColumnLeft: _addColumnLeft,
          onAddColumnRight: _addColumnRight,
          onDeleteRow: _deleteRow,
          onDeleteColumn: _deleteColumn,
          rowIndex: rowIndex,
          columnIndex: columnIndex,
        );
      },
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

  void _deleteRow(int rowIndex) {
    setState(() {
      widget.excelSheets![_selectedSheetIndex].removeAt(rowIndex);
    });
  }

  void _deleteColumn(int columnIndex) {
    setState(() {
      for (int i = 0;
          i < widget.excelSheets![_selectedSheetIndex].length;
          i++) {
        widget.excelSheets![_selectedSheetIndex][i].removeAt(columnIndex);
      }
    });
  }
}
