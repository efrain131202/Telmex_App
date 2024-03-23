import 'package:flutter/material.dart';

class ExcelDataViewer extends StatefulWidget {
  final List<List<List<dynamic>>>? excelSheets;

  // ignore: use_key_in_widget_constructors
  const ExcelDataViewer({Key? key, required this.excelSheets});

  @override
  State<ExcelDataViewer> createState() => _ExcelDataViewerState();
}

class _ExcelDataViewerState extends State<ExcelDataViewer> {
  int _selectedSheetIndex = 0;
  bool _showColumnHeaders = true;
  bool _showRowHeaders = true;
  bool _showGridLines = true;

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>>? currentSheet =
        widget.excelSheets?[_selectedSheetIndex];
    return currentSheet != null
        ? Column(
            children: [
              DropdownButton<int>(
                value: _selectedSheetIndex,
                items: List.generate(
                  widget.excelSheets!.length,
                  (index) => DropdownMenuItem(
                    value: index,
                    child: Text('Hoja ${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedSheetIndex = value!;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showColumnHeaders = !_showColumnHeaders;
                      });
                    },
                    icon: Icon(
                      _showColumnHeaders
                          ? Icons.view_column_outlined
                          : Icons.view_column_rounded,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showRowHeaders = !_showRowHeaders;
                      });
                    },
                    icon: Icon(
                      _showRowHeaders
                          ? Icons.view_stream_outlined
                          : Icons.view_stream_rounded,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showGridLines = !_showGridLines;
                      });
                    },
                    icon: Icon(
                      _showGridLines
                          ? Icons.grid_on_outlined
                          : Icons.grid_off_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(),
                      border: _showGridLines
                          ? TableBorder.all(
                              color: Colors.blue.shade200,
                              style: BorderStyle.solid,
                              width: 1,
                            )
                          : null,
                      children: [
                        if (_showColumnHeaders)
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                            ),
                            children: [
                              if (_showRowHeaders)
                                const TableCell(
                                  child: SizedBox(),
                                ),
                              for (int columnIndex = 0;
                                  columnIndex < currentSheet[0].length;
                                  columnIndex++)
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Columna $columnIndex',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        for (int rowIndex = 0;
                            rowIndex < currentSheet.length;
                            rowIndex++)
                          TableRow(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _showGridLines
                                    ? Colors.blue.shade200
                                    : Colors.transparent,
                              ),
                            ),
                            children: [
                              if (_showRowHeaders)
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Fila $rowIndex',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              for (int columnIndex = 0;
                                  columnIndex < currentSheet[rowIndex].length;
                                  columnIndex++)
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      currentSheet[rowIndex][columnIndex] ==
                                              null
                                          ? ''
                                          : currentSheet[rowIndex][columnIndex]
                                              .toString(),
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
                    ),
                  ),
                ),
              ),
            ],
          )
        : const Center(
            child: Text(
              'No se han importado datos',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          );
  }
}
