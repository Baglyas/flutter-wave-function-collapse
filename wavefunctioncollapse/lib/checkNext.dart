import 'package:wavefunctioncollapse/canconnect.dart';
import 'package:wavefunctioncollapse/main.dart';
import 'package:wavefunctioncollapse/roads.dart';

void checkNext(int x, int y) {
  final cell = roads![x][y];

  if (!cell.isCollapsed || cell.collapsedTile == null) return;

  // Helper function to filter valid tiles
  void _filterValidTiles(int nextX, int nextY, String direction) {
    if (nextX < 0 ||
        nextY < 0 ||
        nextX >= roads!.length ||
        nextY >= roads![nextX].length ||
        roads![nextX][nextY].isCollapsed) return;

    roads![nextX][nextY].possibleTiles = roads![nextX][nextY]
        .possibleTiles
        .where((tile) => canConnect(tile, cell.collapsedTile!, direction))
        .toList();
  }

  // Check all four directions
  final directions = {
    "Left": [x, y - 1],
    "Right": [x, y + 1],
    "Up": [x - 1, y],
    "Down": [x + 1, y]
  };

  directions.forEach((direction, coords) {
    _filterValidTiles(coords[0], coords[1], direction);
  });
}
