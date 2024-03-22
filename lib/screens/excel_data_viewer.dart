import 'package:flutter/material.dart';

class ExcelDataViewer extends StatefulWidget {
  final List<List<dynamic>>? excelData;

  const ExcelDataViewer({super.key, required this.excelData});

  @override
  State<ExcelDataViewer> createState() => _ExcelDataViewerState();
}

class _ExcelDataViewerState extends State<ExcelDataViewer> {
  bool _showColumnHeaders = true;
  bool _showRowHeaders = true;
  bool _showGridLines = true;

  @override
  Widget build(BuildContext context) {
    return widget.excelData != null
        ? Column(
            children: [
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
                                  columnIndex < widget.excelData![0].length;
                                  columnIndex++)
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Column $columnIndex',
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
                            rowIndex < widget.excelData!.length;
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
                                      'Row $rowIndex',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              for (int columnIndex = 0;
                                  columnIndex <
                                      widget.excelData![rowIndex].length;
                                  columnIndex++)
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.excelData![rowIndex][columnIndex]
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
            child: Text('No se han importado datos'),
          );
  }
}
