import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_quest/SnakeGame/room_page.dart';
import 'package:fin_quest/pool_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class decisionPage extends StatefulWidget {
  final String customerId;
  final String gameName;
  decisionPage({required this.customerId,required this.gameName, Key? key}) : super(key: key);

  @override
  _decisionPageState createState() => _decisionPageState();
}

class _decisionPageState extends State<decisionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color.fromARGB(255, 255, 17, 0),
        title: Text('Room'),
      ),
      body: Stack(
  children: <Widget>[
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/room_menu_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PoolSelectionPage(customerId: widget.customerId,gameName: widget.gameName,),
              ),
            );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: Size(300, 150),
                ),
                child: Text(
                  "Join Room",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Poppins",
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
              try {
                DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.customerId)
                    .get();

                if (userSnapshot.exists) {
                  // Checking if the document with the given customer ID exists.
                  dynamic currentPool = userSnapshot.get('currentPool');
                  dynamic currentRoom = userSnapshot.get('currentRoom');

                  if (currentPool != null && currentRoom != null) {
                    String pool = currentPool.toString();
                    String room = currentRoom.toString();
                  } else {
                  }
                } else {
                }
              } catch (e) {
                print('Error: $e');
              }

                  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoomPage(customerId: widget.customerId,gameName: widget.gameName,),
              ),
            );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: Size(300, 150), 
                ),
                child: Text(
                  "My Room",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Poppins",
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 40),
              ElevatedButton(
  onPressed: () async {
    String currentPool = '';  
    String currentRoom = '';  

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.customerId)
          .get();

      if (userSnapshot.exists) {
        currentPool = userSnapshot.get('currentPool') ?? '';
        currentRoom = userSnapshot.get('currentRoom') ?? '';
      }
    } catch (e) {
      print('Error: $e');
    }

    if (currentPool.isNotEmpty && currentRoom.isNotEmpty) {
      await removePlayerDataFromRoom(widget.customerId, currentPool, currentRoom);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.customerId)
          .update({
        'currentPool': null,
        'currentRoom': null,
      });
    }
  },
  style: ElevatedButton.styleFrom(
    primary: Colors.white.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    minimumSize: Size(300, 150),
  ),
  child: Text(
    "Clear Room",
    style: TextStyle(
      fontSize: 30,
      fontFamily: "Poppins",
      color: Colors.white,
    ),
  ),
),



            ],
          ),
        ),
      ),
    ),
  ],
),

    );
  }
  removePlayerDataFromRoom(String customerId, String currentPool, String currentRoom) async {
  try {
    await FirebaseFirestore.instance
        .collection('${currentPool}_rooms')
        .doc(currentRoom)
        .collection('player_data')
        .doc(customerId)
        .delete();
  } catch (e) {
    print('Error: $e');
  }
}

}
