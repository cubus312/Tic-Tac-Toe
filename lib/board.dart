import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  final List<List<String>> boardState;
  final Function(int, int) onTilePressed;

  Board({required this.boardState, required this.onTilePressed});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: 9,
          itemBuilder: (BuildContext context, int index) {
            int row = index ~/ 3;
            int col = index % 3;

            return GestureDetector(
              onTap: () {
                onTilePressed(row, col);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    boardState[row][col],
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
