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
  final List<String> pools = ['100', '200', '500'];

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

  // Query rooms with available space
  final vacantRooms = await roomsCollection.where('currentOccupancy', isLessThan: 10).get();

  if (vacantRooms.docs.isNotEmpty) {
    // Find the first available room
    final roomDoc = vacantRooms.docs[0];
    final roomId = roomDoc.id;

    // Check if the customer's ID is not already in the 'players' array
    if (!(roomDoc['players'] as List).contains(customerId)) {
      // Update the room's occupancy and add the customer
      await roomsCollection.doc(roomId).update({
        'currentOccupancy': FieldValue.increment(1),
        'players': FieldValue.arrayUnion([customerId]),
      });
      
      // Update the user's currentPool in the 'users' collection
      await usersCollection.doc(customerId).update({
        'currentPool': pool,
      });
    }

    // Navigate to the room page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => roomPage(), // Pass the room ID to the RoomPage
      ),
    );
  } else {
    // Create a new room if no vacant rooms are available
    final newRoom = await roomsCollection.add({
      'currentOccupancy': 1, // Initialize with the customer
      'players': [customerId],
      'pool': pool,
      // You can add other room properties as needed
    });

    // Update the user's currentPool in the 'users' collection
    await usersCollection.doc(customerId).update({
        'currentPool': pool,
      });

    // Get the ID of the newly created room
    final roomId = newRoom.id;

    // Navigate to the room page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => roomPage(), // Pass the room ID to the RoomPage
      ),
    );
  }
}




}
