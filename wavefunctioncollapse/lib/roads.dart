import 'dart:math';
import 'package:wavefunctioncollapse/checkNext.dart';
import 'package:wavefunctioncollapse/main.dart';

/// Represents a single cell in the grid that holds possible road tiles.
class RoadCell {
  final int x;
  final int y;
  List<RoadTile> possibleTiles;
  RoadTile? collapsedTile;
  bool isCollapsed;

  RoadCell({
    required this.x,
    required this.y,
    required this.possibleTiles,
    this.collapsedTile,
    this.isCollapsed = false,
  });

  @override
  String toString() =>
      'RoadCell(x: $x, y: $y, possibleTiles: $possibleTiles, collapsedTile: $collapsedTile, isCollapsed: $isCollapsed)';
}

// create initial roads
List<List<RoadCell>>? roads = List.generate(
  GridSize().rows,
  (x) => List.generate(
    GridSize().cols,
    (y) => RoadCell(
      x: x,
      y: y,
      possibleTiles: List.from(roadTiles), // Ensure each cell has a copy
    ),
  ),
);

/// Collapses a specific cell by choosing a random tile from its possible options.
void collapseCell(int x, int y) {
  final cell = roads![x][y];
  if (cell.isCollapsed) return;

  print('Before collapse - Cell [$x, $y] possibleTiles: ${cell.possibleTiles}');

  final random = Random();
  final selectedTile =
      cell.possibleTiles[random.nextInt(cell.possibleTiles.length)];

  // Collapse the cell with the chosen tile
  cell.collapsedTile = selectedTile;
  cell.isCollapsed = true;
  cell.possibleTiles = [selectedTile];

  checkNext(x, y); // Update neighboring cells

  print('After collapse - Cell [$x, $y] possibleTiles: ${cell.possibleTiles}');
}
