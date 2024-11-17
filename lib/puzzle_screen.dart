import 'dart:collection';

import 'package:flutter/material.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  List<List<int>> tiles = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 0]
  ];

  final List<List<int>> targetState = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 0]
  ];

  @override
  void initState() {
    super.initState();
    shuffleTiles();
  }

  void shuffleTiles() {
    List<int> flattenedTiles = List.generate(9, (index) => index)..shuffle();
    int k = 0;
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        tiles[row][col] = flattenedTiles[k++];
      }
    }
    setState(() {});
  }

  void solvePuzzle() async {
    List<List<List<int>>> solution = await bfsSolve(tiles);
    for (var state in solution) {
      if (!mounted) return; // check if the widget is still mounted
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        tiles = state;
      });
    }
  }

  Future<List<List<List<int>>>> bfsSolve(List<List<int>> initial) async {
    Queue<List<List<int>>> queue = Queue();
    Set<String> visited = {};
    Map<String, List<List<int>>?> parent = {};

    queue.add(initial);
    visited.add(initial.toString());
    parent[initial.toString()] = null;

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();

      if (current.toString() == targetState.toString()) {
        return constructPath(parent, current);
      }

      for (var neighbor in getNeighbors(current)) {
        if (!visited.contains(neighbor.toString())) {
          queue.add(neighbor);
          visited.add(neighbor.toString());
          parent[neighbor.toString()] = current;
        }
      }
    }

    return [];
  }

  List<List<List<int>>> constructPath(
      Map<String, List<List<int>>?> parent, List<List<int>> target) {
    List<List<List<int>>> path = [];
    List<List<int>>? current = target;

    while (current != null) {
      path.add(current);
      current = parent[current.toString()];
    }

    return path.reversed.toList();
  }

  List<List<List<int>>> getNeighbors(List<List<int>> state) {
    List<List<List<int>>> neighbors = [];
    int emptyRow = -1, emptyCol = -1;

    // Find the position of the empty tile (0)
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (state[row][col] == 0) {
          emptyRow = row;
          emptyCol = col;
          break;
        }
      }
    }

    // Possible moves: up, down, left, right
    List<List<int>> directions = [
      [-1, 0], // Up
      [1, 0],  // Down
      [0, -1], // Left
      [0, 1]   // Right
    ];

    for (var dir in directions) {
      int newRow = emptyRow + dir[0];
      int newCol = emptyCol + dir[1];

      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3) {
        List<List<int>> newState = copyState(state);
        newState[emptyRow][emptyCol] = newState[newRow][newCol];
        newState[newRow][newCol] = 0;
        neighbors.add(newState);
      }
    }

    return neighbors;
  }

  List<List<int>> copyState(List<List<int>> state) {
    return state.map((row) => List<int>.from(row)).toList();
  }

  bool isSolved() {
    return tiles.toString() == targetState.toString();
  }

  void onTileTap(int row, int col) {
    int emptyRow = -1, emptyCol = -1;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (tiles[i][j] == 0) {
          emptyRow = i;
          emptyCol = j;
          break;
        }
      }
    }

    if ((row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1)) {
      setState(() {
        tiles[emptyRow][emptyCol] = tiles[row][col];
        tiles[row][col] = 0;
      });

      if (isSolved()) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Congratulations!'),
              content: const Text('You solved the puzzle!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '8-Puzzle Game',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: 9,
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => onTileTap(row, col),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: tiles[row][col] == 0
                            ? Colors.grey.shade300
                            : Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(15),
                        gradient: tiles[row][col] != 0
                            ? const LinearGradient(
                                colors: [Colors.purple, Colors.deepPurple],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        boxShadow: [
                          if (tiles[row][col] != 0)
                            const BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          tiles[row][col] == 0 ? '' : '${tiles[row][col]}',
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: shuffleTiles,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Shuffle',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: solvePuzzle,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Solve',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
