import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_quest/SnakeGame/room_page.dart';
import 'package:flutter/material.dart';

class PoolSelectionPage extends StatefulWidget {
  final String customerId;
  final String gameName;
  PoolSelectionPage({required this.customerId,required this.gameName, Key? key}) : super(key: key);
  @override
  _PoolSelectionPageState createState() => _PoolSelectionPageState();
}

class _PoolSelectionPageState extends State<PoolSelectionPage> {
  final List<String> pools = ['10', '20', '50'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 17, 0),
        title: Text('Select the Pool'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final pool in pools)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(250, 170),
                    ),
                    onPressed: () {
                      checkAndEnterRoom(context,widget.customerId, pool);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/m_coins.png',
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(width: 10),
                        Text(
                          pool,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
Future<void> checkAndEnterRoom(BuildContext context, String customerId, String pool) async {
  final firestore = FirebaseFirestore.instance;
  final roomsCollection = firestore.collection('${pool}_rooms');
  final usersCollection = firestore.collection('users');
  final userDoc = await usersCollection.doc(customerId).get();
  final handle = userDoc.get('handle');
  final userCoins = userDoc.get('m_coins'); 

  if (userCoins >= int.parse(pool)) {

    final vacantRooms = await roomsCollection.where('currentOccupancy', isLessThan: 5).where('gameName', isEqualTo: widget.gameName).
get();

    if (vacantRooms.docs.isNotEmpty) {
      final roomDoc = vacantRooms.docs[0];
      final roomId = roomDoc.id;

      final playerDataDoc = await roomsCollection.doc(roomId).collection('player_data').doc(customerId).get();
      if (!playerDataDoc.exists) {
        await roomsCollection.doc(roomId).update({
          'currentOccupancy': FieldValue.increment(1),
          'total_pool': FieldValue.increment(int.parse(pool)),
        });

        await roomsCollection.doc(roomId).collection('player_data').doc(customerId).set({
          'score': 0,
          'handle': handle,
          'game_over': false,
        });

        await usersCollection.doc(customerId).update({
          'currentPool': pool,
          'currentRoom': roomId,
        });
        await usersCollection.doc(customerId).update({
          'm_coins': FieldValue.increment(-int.parse(pool)),
        });
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(customerId: customerId,gameName : widget.gameName), // Pass the room ID to the RoomPage
        ),
      );
    } else {
      final newRoom = await roomsCollection.add({
        'currentOccupancy': 1,
        'pool': pool,
        'total_pool': int.parse(pool),
        'result_published': false,
        'gameName': widget.gameName,
      });

      await newRoom.collection('player_data').doc(customerId).set({
        'score': 0,
        'handle': handle,
        'game_over': false,
      });

      await usersCollection.doc(customerId).update({
        'currentPool': pool,
        'currentRoom': newRoom.id,
      });

      await usersCollection.doc(customerId).update({
        'm_coins': FieldValue.increment(-int.parse(pool)),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(customerId: customerId,gameName : widget.gameName),
        ),
      );
    }
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Insufficient Coins'),
          content: Text('You do not have enough coins to join this pool.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


}
