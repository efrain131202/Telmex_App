import 'package:flutter/material.dart';

class ExcelDataViewer extends StatefulWidget {
  final List<List<List<dynamic>>>? excelSheets;

  // ignore: use_super_parameters
  const ExcelDataViewer({Key? key, required this.excelSheets})
      : super(key: key);

  @override
  State<ExcelDataViewer> createState() => _ExcelDataViewerState();
}

class _ExcelDataViewerState extends State<ExcelDataViewer>
    with SingleTickerProviderStateMixin {
  int _selectedSheetIndex = 0;
  bool _showColumnHeaders = true;
  bool _showRowHeaders = true;
  double _scale = 1.0;

  late AnimationController _animationController;
  late Animation<double> _animation;

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                        const SizedBox(width: 8.0),
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
                      ],
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
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Transform.scale(
                      scale: _scale,
                      child: Table(
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        border: TableBorder.all(
                          color: Colors.blue.shade300,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
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
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          for (int rowIndex = 0;
                              rowIndex < currentSheet.length;
                              rowIndex++)
                            TableRow(
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
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
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
                                            : currentSheet[rowIndex]
                                                    [columnIndex]
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
              ),
            ],
          )
        : Center(
            child: FadeTransition(
              opacity: _animation,
              child: const Text(
                '¡No se han importado datos!',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          );
  }
}
