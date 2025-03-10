import 'package:flutter/material.dart';
import 'package:wavefunctioncollapse/canconnect.dart';
import 'package:wavefunctioncollapse/checkNext.dart';
import 'package:wavefunctioncollapse/findCollapsed.dart';
import 'package:wavefunctioncollapse/findLeastOptions.dart';
import 'package:wavefunctioncollapse/roads.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: RoadGrid(),
      ),
    );
  }
}

class RoadGrid extends StatefulWidget {
  @override
  _RoadGridState createState() => _RoadGridState();
}

class _RoadGridState extends State<RoadGrid> {
  int rows = GridSize().rows;
  int columns = GridSize().cols;

  @override
  void initState() {
    super.initState();
  }

  void _updateGridSize(int newRows, int newCols) {
    setState(() {
      rows = newRows;
      columns = newCols;
      // Resize roads array properly

      roads = List.generate(
          rows,
          (x) => List.generate(
              columns,
              (y) =>
                  RoadCell(x: x, y: y, possibleTiles: List.from(roadTiles))));
    });
  }

  Future<void> _runCollapseStep() async {
    while (findCollapsed()) {
      setState(() {});
      await Future.delayed(Duration(milliseconds: 100));
      RoadCell leastOptions = findLeastOptions();
      collapseCell(leastOptions.x, leastOptions.y);
      checkNext(leastOptions.x, leastOptions.y);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int gridSize = GridSize().cols * GridSize().rows;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _runCollapseStep,
                child: Text('Start'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Rows: ", style: TextStyle(color: Colors.white)),
                  Expanded(
                    child: Slider(
                      value: rows.toDouble(),
                      min: 2,
                      max: 8,
                      divisions: 6,
                      label: rows.toString(),
                      onChanged: (value) {
                        setState(() {
                          rows = value.toInt();
                          _updateGridSize(rows, columns);
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Columns: ", style: TextStyle(color: Colors.white)),
                  Expanded(
                    child: Slider(
                      value: columns.toDouble(),
                      min: 2,
                      max: 8,
                      divisions: 6,
                      label: columns.toString(),
                      onChanged: (value) {
                        setState(() {
                          columns = value.toInt();
                          _updateGridSize(rows, columns);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
            ),
            itemBuilder: (context, index) {
              int x = index ~/ columns;
              int y = index % columns;
              if (!roads![x][y].isCollapsed) {
                return Container(
                  color: Colors.deepPurpleAccent,
                  child:
                      Center(child: Text('Empty', textAlign: TextAlign.center)),
                );
              } else {
                return RoadTileWidget(roads![x][y].collapsedTile!);
              }
            },
            itemCount: rows * columns,
          ),
        ),
      ],
    );
  }
}

class RoadTileWidget extends StatelessWidget {
  final RoadTile tile;

  RoadTileWidget(this.tile);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, index) {
            int row = index ~/ 3;
            int col = index % 3;
            int value = tile.pattern[row][col];
            return Container(
              decoration: BoxDecoration(
                color: value == 1 ? Colors.white : Colors.black,
              ),
              child: Center(child: Text(value.toString())),
            );
          },
        ),
      ),
    );
  }
}

class RoadTile {
  final List<List<int>> pattern;
  final String id;

  RoadTile(this.id, this.pattern);

  @override
  String toString() => 'RoadTile(pattern: $pattern, id: $id)';
}

final roadTiles = [
  RoadTile('Up', [
    [0, 1, 0],
    [1, 1, 1],
    [0, 0, 0]
  ]),
  RoadTile('Down', [
    [0, 0, 0],
    [1, 1, 1],
    [0, 1, 0]
  ]),
  RoadTile('Right', [
    [0, 1, 0],
    [0, 1, 1],
    [0, 1, 0]
  ]),
  RoadTile('Left', [
    [0, 1, 0],
    [1, 1, 0],
    [0, 1, 0]
  ]),
  RoadTile('Empty', [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
  ]),
  RoadTile('Full', [
    [0, 1, 0],
    [1, 1, 1],
    [0, 1, 0]
  ])
];

class GridSize {
  int rows = 6;
  int cols = 6;
}
