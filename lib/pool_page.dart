import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_quest/SnakeGame/room_page.dart';
import 'package:flutter/material.dart';

class PoolSelectionPage extends StatefulWidget {
  final String customerId;
  PoolSelectionPage({required this.customerId, Key? key}) : super(key: key);
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
                      primary: Colors.transparent, // Set button color to transparent
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(250, 170),
                    ),
                    onPressed: () {
                      checkAndEnterRoom(widget.customerId, pool);
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
 Future<void> checkAndEnterRoom(String customerId, String pool) async {
  final firestore = FirebaseFirestore.instance;
  final roomsCollection = firestore.collection('${pool}_rooms');
  final usersCollection = firestore.collection('users');
  final userDoc = await usersCollection.doc(customerId).get();
      final handle = userDoc.get('handle');

  // Query rooms with available space
  final vacantRooms = await roomsCollection.where('currentOccupancy', isLessThan: 5).get();

  if (vacantRooms.docs.isNotEmpty) {
    // Find the first available room
    final roomDoc = vacantRooms.docs[0];
    final roomId = roomDoc.id;

    // Check if a document with customerId exists inside the 'player_data' subcollection
    final playerDataDoc = await roomsCollection.doc(roomId).collection('player_data').doc(customerId).get();
    if (!playerDataDoc.exists) {
      // Update the room's occupancy and add the customer to 'player_data'
      await roomsCollection.doc(roomId).update({
        'currentOccupancy': FieldValue.increment(1),
        'total_pool':FieldValue.increment(int.parse(pool)),
      });

      // Add the customer as a document with customerId as the name inside 'player_data'
      await roomsCollection.doc(roomId).collection('player_data').doc(customerId).set({
        'score': 0,
        'handle': handle,
        'game_over': false,
      });

      // Update the user's currentPool and currentRoom in the 'users' collection
      await usersCollection.doc(customerId).update({
        'currentPool': pool,
        'currentRoom': roomId,
      });
      //substract ${pool} m_coins of the user 
      await usersCollection.doc(customerId).update({
        'm_coins': FieldValue.increment(-int.parse(pool)),
      });
    }

    // Navigate to the room page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomPage(customerId: customerId), // Pass the room ID to the RoomPage
      ),
    );
  } else {
    // Create a new room if no vacant rooms are available
    final newRoom = await roomsCollection.add({
      'currentOccupancy': 1, // Initialize with the customer
      'pool': pool,
      'total_pool': int.parse(pool),
      // You can add other room properties as needed
    });

    // Add the customer as a document with customerId as the name inside 'player_data' of the new room
    await newRoom.collection('player_data').doc(customerId).set({
      'score': 0,
      'handle': handle,
      'game_over': false,
      
    });

    // Update the user's currentPool and currentRoom in the 'users' collection
    await usersCollection.doc(customerId).update({
      'currentPool': pool,
      'currentRoom': newRoom.id,
    });

    // Navigate to the room page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomPage(customerId: customerId), // Pass the room ID to the RoomPage
      ),
    );
  }
}

}
