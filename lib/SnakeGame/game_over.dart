import 'package:fin_quest/SnakeGame/snake_game.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {

  final int score;

  GameOver({
    required this.score
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Game Over', style: TextStyle(color: Colors.redAccent, fontSize: 50.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, shadows: [
                Shadow( // bottomLeft
                  offset: Offset(-1.5, -1.5),
                  color: Colors.black
                ),
                Shadow( // bottomRight
                  offset: Offset(1.5, -1.5),
                  color: Colors.black
                ),
                Shadow( // topRight
                  offset: Offset(1.5, 1.5),
                  color: Colors.black
                ),
                Shadow( // topLeft
                  offset: Offset(-1.5, 1.5),
                  color: Colors.black
                ),
              ])
            ),
            
            SizedBox(height: 50.0),

            Text('Your Score is: $score', style: TextStyle(color: Colors.white, fontSize: 20.0)),

            SizedBox(height: 50.0),

            ElevatedButton(
  onPressed: () {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GamePage()));
  },
  style: ElevatedButton.styleFrom(
    primary: Colors.blue, // Change the button background color to your preferred color
    minimumSize: Size(150, 50), // Set the button's minimum size
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.refresh,
        color: Colors.white,
        size: 30.0,
      ),
      SizedBox(width: 10.0), // Add spacing between icon and text
      Text(
        "Try Again",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    ],
  ),
)

          ],
        ),
      )
    );
  }
}