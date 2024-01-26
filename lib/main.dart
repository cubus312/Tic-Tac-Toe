import 'dart:async';
import 'package:flutter/material.dart';
import 'board.dart';
import 'dart:math';
import 'main_menu.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainMenu(), // Set MainMenu as the initial screen
    );
  }
}
class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  late List<List<String>> boardState;
  late bool isPlayer1Turn;
  late bool gameOver;
  Timer? timer;


  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    timer?.cancel();
    setState(() {
      boardState = List.generate(3, (i) => List.generate(3, (j) => ''));
      isPlayer1Turn = true;
      gameOver = false;
    });
  }

  void onTilePressed(int row, int col) {
    if (!gameOver && boardState[row][col] == '' && isPlayer1Turn) {
      makeMove(row, col, 'X');
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
    } else if (!isPlayer1Turn) {
      // If it's not a game over, make AI move after a short delay.
      timer = Timer(Duration(seconds: 1), () {
        makeAIMove();
        if (checkForWinner()) {
          showGameOverDialog();
        } else if (isBoardFull()) {
          showDrawDialog();
        }
      });
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

  void makeAIMove() {
    // Use the minimax algorithm to find the best move.
    int bestScore = -1000;
    int bestMove = -1;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (boardState[i][j] == '') {
          boardState[i][j] = 'O';
          int score = minimax(boardState, 0, false);
          boardState[i][j] = '';

          if (score > bestScore) {
            bestScore = score;
            bestMove = i * 3 + j;
          }
        }
      }
    }

    if (bestMove != -1) {
      int row = bestMove ~/ 3;
      int col = bestMove % 3;
      makeMove(row, col, 'O');
    }
  }

  int minimax(List<List<String>> board, int depth, bool isMaximizing) {
    int score = evaluate(board);

    if (score == 10 || score == -10) {
      return score;
    }

    if (!isMovesLeft(board)) {
      return 0;
    }

    if (isMaximizing) {
      int best = -1000;

      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == '') {
            board[i][j] = 'O';
            best = max(best, minimax(board, depth + 1, !isMaximizing));
            board[i][j] = '';
          }
        }
      }

      return best;
    } else {
      int best = 1000;

      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == '') {
            board[i][j] = 'X';
            best = min(best, minimax(board, depth + 1, !isMaximizing));
            board[i][j] = '';
          }
        }
      }

      return best;
    }
  }

  int evaluate(List<List<String>> board) {
    // Check rows, columns, and diagonals for a winner.
    for (int row = 0; row < 3; row++) {
      if (board[row][0] == board[row][1] && board[row][1] == board[row][2]) {
        if (board[row][0] == 'O') return 10;
        if (board[row][0] == 'X') return -10;
      }
    }

    for (int col = 0; col < 3; col++) {
      if (board[0][col] == board[1][col] && board[1][col] == board[2][col]) {
        if (board[0][col] == 'O') return 10;
        if (board[0][col] == 'X') return -10;
      }
    }

    if (board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
      if (board[0][0] == 'O') return 10;
      if (board[0][0] == 'X') return -10;
    }

    if (board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
      if (board[0][2] == 'O') return 10;
      if (board[0][2] == 'X') return -10;
    }

    // If no winner, return 0 (draw).
    return 0;
  }

  bool isMovesLeft(List<List<String>> board) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          return true;
        }
      }
    }
    return false;
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
        title: Text('Tic Tac Toe'),
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
