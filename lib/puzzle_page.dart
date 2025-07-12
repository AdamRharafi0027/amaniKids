import 'package:flutter/material.dart';
import 'dart:math';

class PuzzlePage extends StatefulWidget {
  final String folderName;

  const PuzzlePage({Key? key, required this.folderName}) : super(key: key);

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  late List<int?> tiles;
  final int gridSize = 3;
  int? emptyTileIndex;

  @override
  void initState() {
    super.initState();
    _shuffleTiles();
  }

  void _shuffleTiles() {
    tiles = List.generate(gridSize * gridSize, (index) => index < (gridSize * gridSize - 1) ? index + 1 : null);
    emptyTileIndex = gridSize * gridSize - 1;

    // Fisher-Yates shuffle algorithm
    for (int i = 0; i < tiles.length - 1; i++) {
      int j = i + Random().nextInt(tiles.length - i - 1);
      var temp = tiles[i];
      tiles[i] = tiles[j];
      tiles[j] = temp;
    }

    // Ensure the puzzle is solvable
    if (!_isSolvable()) {
      int first = 0;
      while (tiles[first] == null) first++;
      int second = first + 1;
      while (tiles[second] == null) second++;

      var temp = tiles[first];
      tiles[first] = tiles[second];
      tiles[second] = temp;
    }
  }

  bool _isSolvable() {
    int inversions = 0;
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != null) {
        for (int j = i + 1; j < tiles.length; j++) {
          if (tiles[j] != null && tiles[i]! > tiles[j]!) {
            inversions++;
          }
        }
      }
    }
    return inversions % 2 == 0;
  }

  bool _isSolved() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) {
        return false;
      }
    }
    return tiles.last == null;
  }

  void _swapTiles(int fromIndex) {
    int emptyRow = emptyTileIndex! ~/ gridSize;
    int emptyCol = emptyTileIndex! % gridSize;
    int fromRow = fromIndex ~/ gridSize;
    int fromCol = fromIndex % gridSize;

    if ((emptyRow == fromRow && (emptyCol - fromCol).abs() == 1) ||
        (emptyCol == fromCol && (emptyRow - fromRow).abs() == 1)) {
      setState(() {
        tiles[emptyTileIndex!] = tiles[fromIndex];
        tiles[fromIndex] = null;
        emptyTileIndex = fromIndex;

        if (_isSolved()) {
          _showWinDialog();
        }
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تهانينا!', style: TextStyle(fontFamily: 'Cairo')),
        content: Text('لقد أكملت اللغز بنجاح!', style: TextStyle(fontFamily: 'Cairo')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _shuffleTiles();
            },
            child: Text('إعادة', style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة الألغاز', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _shuffleTiles,
            tooltip: 'إعادة',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            crossAxisSpacing: 0, // Remove spacing between tiles
            mainAxisSpacing: 0,  // Remove spacing between tiles
          ),
          itemCount: tiles.length,
          itemBuilder: (context, index) {
            final tile = tiles[index];

            return DragTarget<int>(
              onAccept: (fromIndex) => _swapTiles(fromIndex),
              builder: (context, candidateData, rejectedData) {
                return Draggable<int>(
                  data: index,
                  feedback: _buildTile(tile, isDragging: true),
                  childWhenDragging: Container(
                    color: Colors.transparent, // Make empty space transparent
                  ),
                  child: _buildTile(tile),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTile(int? tile, {bool isDragging = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 5,
        ),
      ),
      child: tile == null
          ? null
          : Image.asset(
        'assets/images/${widget.folderName}/$tile.jpg',
        fit: BoxFit.cover, // Changed to fill to take full box size
      ),
    );
  }
}