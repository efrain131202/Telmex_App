import 'package:flutter/material.dart';

class ExcelDataViewer extends StatefulWidget {
  final List<List<List<dynamic>>>? excelSheets;

  const ExcelDataViewer({super.key, required this.excelSheets});

  @override
  State<ExcelDataViewer> createState() => _ExcelDataViewerState();
}

class _ExcelDataViewerState extends State<ExcelDataViewer>
    with SingleTickerProviderStateMixin {
  int _selectedSheetIndex = 0;
  double _scale = 1.0;

  late AnimationController _animationController;
  late Animation<double> _animation;

  String _searchTerm = '';

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

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>>? currentSheet =
        widget.excelSheets?[_selectedSheetIndex];
    return currentSheet != null
        ? Column(
            children: [
              _buildToolbar(),
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
          )
        : Center(
            child: FadeTransition(
              opacity: _animation,
              child: const Text(
                'No se han importado datos',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<int>(
            value: _selectedSheetIndex,
            items: List.generate(
              widget.excelSheets!.length,
              (index) => DropdownMenuItem(
                value: index,
                child: Text(
                  'Hoja ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _selectedSheetIndex = value!;
              });
            },
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _scale = _scale - 0.1;
                  });
                },
                icon: const Icon(
                  Icons.zoom_out_rounded,
                  color: Colors.black,
                ),
              ),
              Text(
                '${(_scale * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _scale = _scale + 0.1;
                  });
                },
                icon: const Icon(
                  Icons.zoom_in_rounded,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar...',
              ),
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<List<dynamic>> sheet) {
    List<List<dynamic>> filteredRows = sheet.where((row) {
      for (var cell in row) {
        if (cell != null && cell.toString().contains(_searchTerm)) {
          return true;
        }
      }
      return false;
    }).toList();

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder.all(
        color: Colors.blue.shade300,
        style: BorderStyle.solid,
        width: 1,
      ),
      children: [
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        for (int rowIndex = 0; rowIndex < filteredRows.length; rowIndex++)
          TableRow(
            decoration: BoxDecoration(
              color: rowIndex % 2 == 0 ? Colors.grey.shade200 : Colors.white,
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
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      filteredRows[rowIndex][columnIndex] == null
                          ? ''
                          : filteredRows[rowIndex][columnIndex].toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
