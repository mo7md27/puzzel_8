import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PuzzleScreen(),
    );
  }
}

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  List<List<int>> tiles = [
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

  void solvePuzzle() {
    // Set tiles to solved order
    tiles = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 0]
    ];
    setState(() {});
  }

  bool isSolved() {
    List<int> orderedList = List.generate(9, (index) => index + 1);
    orderedList[8] = 0;
    int k = 0;
    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 3; col++) {
        if (tiles[row][col] != orderedList[k]) return false;
        k++;
      }
    }
    return true;
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
        title: const Text('8-Puzzle Game', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: 9,
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => onTileTap(row, col),
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: tiles[row][col] == 0
                            ? Colors.grey.shade300
                            : Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(12),
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
                      borderRadius: BorderRadius.circular(8),
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
                      borderRadius: BorderRadius.circular(8),
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
