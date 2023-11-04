import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_quest/SnakeGame/room_page.dart';
import 'package:fin_quest/SnakeGame/snake_game.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {

  final int score;

final String customerId;
  GameOver({required this.customerId,required this.score, Key? key}) : super(key: key);


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
                Shadow(
                  offset: Offset(-1.5, -1.5),
                  color: Colors.black
                ),
                Shadow(
                  offset: Offset(1.5, -1.5),
                  color: Colors.black
                ),
                Shadow( 
                  offset: Offset(1.5, 1.5),
                  color: Colors.black
                ),
                Shadow(
                  offset: Offset(-1.5, 1.5),
                  color: Colors.black
                ),
              ])
            ),
            
            SizedBox(height: 50.0),

            Text('Your Score is: $score', style: TextStyle(color: Colors.white, fontSize: 20.0)),

            SizedBox(height: 50.0),

            ElevatedButton(
              onPressed: () async {
                try {
                  DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(customerId)
                      .get();

                  if (userSnapshot.exists) {
                    dynamic currentPool = userSnapshot.get('currentPool');
                    dynamic currentRoom = userSnapshot.get('currentRoom');

                    if (currentPool != null && currentRoom != null) {
                      String pool = currentPool.toString();
                      String room = currentRoom.toString();
                      await FirebaseFirestore.instance
                          .collection('$pool' + '_rooms')
                          .doc(room)
                          .collection('player_data')
                          .doc(customerId)
                          .update({'score': score});

                      await FirebaseFirestore.instance
                          .collection('$pool' + '_rooms')
                          .doc(room)
                          .collection('player_data')
                          .doc(customerId)
                          .update({'game_over': true});
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RoomPage(customerId: customerId,gameName: 'Snake',),
                        ),
                      );
                    } else {
                    }
                  } else {
                  }
                } catch (e) {
                  print('Error: $e');
                }
              },

              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 255, 0, 0), 
                minimumSize: Size(150, 50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Proceed",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.arrow_forward_outlined,
                    color: Colors.white,
                    size: 30.0,
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