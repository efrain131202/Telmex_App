import 'package:flutter/material.dart';

class CellOptions extends StatelessWidget {
  final Function(int) onAddRowAbove;
  final Function(int) onAddRowBelow;
  final Function(int) onAddColumnLeft;
  final Function(int) onAddColumnRight;
  final Function(int) onDeleteRow;
  final Function(int) onDeleteColumn;
  final int rowIndex;
  final int columnIndex;

  const CellOptions({
    super.key,
    required this.onAddRowAbove,
    required this.onAddRowBelow,
    required this.onAddColumnLeft,
    required this.onAddColumnRight,
    required this.onDeleteRow,
    required this.onDeleteColumn,
    required this.rowIndex,
    required this.columnIndex,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'addRowAbove',
            child: ListTile(
              leading: Icon(Icons.arrow_upward, color: Colors.blue),
              title: Text('Agregar fila arriba'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'addRowBelow',
            child: ListTile(
              leading: Icon(Icons.arrow_downward, color: Colors.blue),
              title: Text('Agregar fila abajo'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'addColumnLeft',
            child: ListTile(
              leading: Icon(Icons.arrow_back, color: Colors.blue),
              title: Text('Agregar columna a la izquierda'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'addColumnRight',
            child: ListTile(
              leading: Icon(Icons.arrow_forward, color: Colors.blue),
              title: Text('Agregar columna a la derecha'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'deleteRow',
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Borrar fila', style: TextStyle(color: Colors.red)),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'deleteColumn',
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title:
                  Text('Borrar columna', style: TextStyle(color: Colors.red)),
            ),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case 'addRowAbove':
            onAddRowAbove(rowIndex);
            break;
          case 'addRowBelow':
            onAddRowBelow(rowIndex);
            break;
          case 'addColumnLeft':
            onAddColumnLeft(columnIndex);
            break;
          case 'addColumnRight':
            onAddColumnRight(columnIndex);
            break;
          case 'deleteRow':
            onDeleteRow(rowIndex);
            break;
          case 'deleteColumn':
            onDeleteColumn(columnIndex);
            break;
        }
      },
    );
  }
}
