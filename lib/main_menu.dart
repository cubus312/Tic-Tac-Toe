import 'package:flutter/material.dart';
import 'main.dart';
import 'tic_tac_toe_pvp.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Center(
            child: Image.asset(
              'assets/menu_image.png',
              width: 150,
              height: 150,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Welcome to Tic Tac Toe!',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to the Tic Tac Toe game with a scale and fade transition
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      TicTacToe(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = 0.5;
                    const end = 1.0;
                    const curve = Curves.easeInOutCubic;

                    var scaleTween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var scaleAnimation = animation.drive(scaleTween);

                    var fadeTween = Tween(begin: 0.0, end: 1.0)
                        .chain(CurveTween(curve: curve));
                    var fadeAnimation = animation.drive(fadeTween);

                    return ScaleTransition(
                      scale: scaleAnimation,
                      child: FadeTransition(
                        opacity: fadeAnimation,
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
            child: Text(
              'Player vs CPU',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Shadow',
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to the Tic Tac Toe game with PvP mode
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TicTacToePvP()),
              );
            },
            child: Text(
              'Player vs Player',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Shadow',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

