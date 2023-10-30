import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  final String customerId;
  RoomPage({required this.customerId, Key? key}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Add settings functionality
            },
            icon: Icon(Icons.settings),
          ),
        ],
        backgroundColor: Color.fromRGBO(255, 0, 0, 1),
        centerTitle: true,
        title: const Text(
          "My Room",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            fontFamily: "Poppins",
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.customerId) // Replace customerId with the actual customer ID
            .snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return CircularProgressIndicator(); // Loading indicator while data is being fetched.
          }
          final userData = userSnapshot.data?.data();
          final currentRoom = userData!['currentRoom'];
          final currentPool = userData['currentPool'];

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('${currentPool}_rooms')
                .doc(currentRoom)
                .collection('player_data')
                .snapshots(),
            builder: (context, playerDataSnapshot) {
              if (!playerDataSnapshot.hasData) {
                return CircularProgressIndicator(); // Loading indicator while data is being fetched.
              }
              final playerData = playerDataSnapshot.data?.docs;

              return ListView.builder(
                itemCount: playerData!.length,
                itemBuilder: (ctx, index) {
                  final player = playerData[index].data();
                  // Create a custom postcard widget and pass player data to it.
                  return PostCardWidget(playerData: player);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class PostCardWidget extends StatelessWidget {
  final Map<String, dynamic> playerData;

  PostCardWidget({required this.playerData});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Customize the card design as needed
      child: ListTile(
        title: Text(playerData['handle'].toString()),
        subtitle: Text(playerData['score'].toString()),
        // Add other information from playerData
      ),
    );
  }
}
