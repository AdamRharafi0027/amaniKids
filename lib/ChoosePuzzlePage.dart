import 'package:flutter/material.dart';
import 'puzzle_page.dart';

class ChoosePuzzlePage extends StatelessWidget {
  final List<Map<String, String>> puzzles = [
    {
      'title': 'لغز الأسد',
      'folder': 'lionPuzzle',
      'image': 'assets/images/lion.jpg',
    },
    {
      'title': 'لغز النمر',
      'folder': 'tigerPuzzle',
      'image': 'assets/images/tiger.jpg',
    },
    {
      'title': 'لغز القرد',
      'folder': 'monkeyPuzzle',
      'image': 'assets/images/monkey.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختر لغزاً', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: puzzles.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final puzzle = puzzles[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PuzzlePage(folderName: puzzle['folder']!),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: EdgeInsets.only(bottom: 16),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    puzzle['image']!,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    height: 160,
                    alignment: Alignment.center,
                    child: Text(
                      puzzle['title']!,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
