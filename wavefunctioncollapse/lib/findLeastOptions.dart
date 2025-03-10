import 'dart:math';
import 'package:wavefunctioncollapse/main.dart';
import 'package:wavefunctioncollapse/roads.dart';

RoadCell findLeastOptions() {
  List<RoadCell> list = [];

  for (var row in roads!) {
    for (var cell in row) {
      if (!cell.isCollapsed) {
        list.add(cell);
      }
    }
  }

  if (list.isEmpty) {
    throw Exception("No available cells to collapse.");
  }

  // Sort by the number of possibleTiles (ascending order)
  list.sort((a, b) => a.possibleTiles.length.compareTo(b.possibleTiles.length));

  // Get the minimum possibleTiles length
  int minLength = list.first.possibleTiles.length;

  // Filter to only include cells with the minimum possibleTiles length
  List<RoadCell> candidates =
      list.where((cell) => cell.possibleTiles.length == minLength).toList();

  // Pick a random cell from the candidates
  final random = Random();
  return candidates[random.nextInt(candidates.length)];
}
