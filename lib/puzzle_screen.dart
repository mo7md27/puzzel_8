import 'package:flutter/material.dart';

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
    // تحديد موقع البلاطة الفارغة (0)
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

    // التحقق من إمكانية التحريك (إذا كانت البلاطة بجانب البلاطة الفارغة)
    if ((row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1)) {
      // تبديل البلاطتين
      setState(() {
        tiles[emptyRow][emptyCol] = tiles[row][col];
        tiles[row][col] = 0;
      });

      // عرض رسالة تهنئة إذا تم حل اللغز
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
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
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
