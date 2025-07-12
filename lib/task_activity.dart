import 'dart:ui';
import 'package:flutter/material.dart';
import 'puzzle_page.dart';
import 'ChoosePuzzlePage.dart';

class TaskActivity extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'label': 'الألغاز', 'image': 'assets/images/puzzle.png'},
    {'label': 'أرقام', 'image': 'assets/images/numbers.png'},
    {'label': 'الحيوانات', 'image': 'assets/images/animals.png'},
    {'label': 'الحروف', 'image': 'assets/images/letters.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        leading: BackButton(color: Colors.black),
        title: SizedBox(
          height: 40,
          child: TextField(
            style: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
            decoration: InputDecoration(
              hintText: 'ابحث...',
              hintStyle: TextStyle(color: Colors.black54, fontFamily: 'Cairo'),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.black),
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            tooltip: 'التحكم الأبوي',
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Text(
              'اختار الفئة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        category['image']!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (category['label'] == 'الألغاز') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ChoosePuzzlePage()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: TextStyle(fontFamily: 'Cairo'),
                        ),
                        child: Text(
                          category['label']!,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
