import 'package:flutter/material.dart';
import 'board.dart';

class TicTacToePvP extends StatefulWidget {
  @override
  _TicTacToePvPState createState() => _TicTacToePvPState();
}

class _TicTacToePvPState extends State<TicTacToePvP> {
  late List<List<String>> boardState;
  late bool isPlayer1Turn;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    setState(() {
      boardState = List.generate(3, (i) => List.generate(3, (j) => ''));
      isPlayer1Turn = true;
      gameOver = false;
    });
  }

  void onTilePressed(int row, int col) {
    if (!gameOver && boardState[row][col] == '') {
      makeMove(row, col, isPlayer1Turn ? 'X' : 'O');
    }
  }

  void makeMove(int row, int col, String character) {
    setState(() {
      boardState[row][col] = character;
      isPlayer1Turn = !isPlayer1Turn;
    });

    if (checkForWinner()) {
      showGameOverDialog();
    } else if (isBoardFull()) {
      showDrawDialog();
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Player ${isPlayer1Turn ? 'O' : 'X'} wins!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void showDrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('It\'s a draw!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  bool checkForWinner() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (boardState[i][0] != '' &&
          boardState[i][0] == boardState[i][1] &&
          boardState[i][1] == boardState[i][2]) {
        return true;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (boardState[0][i] != '' &&
          boardState[0][i] == boardState[1][i] &&
          boardState[1][i] == boardState[2][i]) {
        return true;
      }
    }

    // Check diagonals
    if (boardState[0][0] != '' &&
        boardState[0][0] == boardState[1][1] &&
        boardState[1][1] == boardState[2][2]) {
      return true;
    }

    if (boardState[0][2] != '' &&
        boardState[0][2] == boardState[1][1] &&
        boardState[1][1] == boardState[2][0]) {
      return true;
    }

    // If no winner, return false
    return false;
  }

  bool isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (boardState[i][j] == '') {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe - PvP Mode'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Board(boardState: boardState, onTilePressed: onTilePressed),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: resetGame,
            child: Text('Restart Game'),
          ),
        ],
      ),
    );
  }
}
