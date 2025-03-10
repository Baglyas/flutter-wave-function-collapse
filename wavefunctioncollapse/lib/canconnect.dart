import 'package:wavefunctioncollapse/main.dart';

bool canConnect(RoadTile neighbor, RoadTile original, String dir) {
  // direction is for original
  switch (dir) {
    case 'Up':
      return original.pattern[0][1] == neighbor.pattern[2][1];
    case 'Right':
      return original.pattern[1][2] == neighbor.pattern[1][0];
    case 'Down':
      return original.pattern[2][1] == neighbor.pattern[0][1];
    case 'Left':
      return original.pattern[1][0] == neighbor.pattern[1][2];

    default:
      return false;
  }
}
