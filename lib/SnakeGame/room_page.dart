import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_quest/SnakeGame/snake_game.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  final String customerId;

  RoomPage({required this.customerId, Key? key}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  Map<String, dynamic>? userData; // Define userData variable

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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.customerId)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                userData = userSnapshot.data?.data(); // Assign userData here

                final currentRoom = userData!['currentRoom'];
                final currentPool = userData!['currentPool'];

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('${currentPool}_rooms')
                      .doc(currentRoom)
                      .collection('player_data')
                      .orderBy('score', descending: true)
                      .snapshots(),
                  builder: (context, playerDataSnapshot) {
                    if (!playerDataSnapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
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
          ),
          // Button at the bottom of the page
          Row(
  children: [
    Expanded(
      child: Container(
        color: Colors.red,
        child: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {
            if (userData != null) { // Check if userData is available
              final currentPool = userData!['currentPool'];
              final currentRoom = userData!['currentRoom'];

              FirebaseFirestore.instance
                  .collection('$currentPool' + '_rooms')
                  .doc(currentRoom)
                  .collection('player_data')
                  .doc(widget.customerId)
                  .get()
                  .then((playerDoc) {
                if (playerDoc.exists) {
                  final gameStatus = playerDoc.data()?['game_over'];

                  if (gameStatus == false) {
                    // Proceed to the game
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GamePage(customerId: widget.customerId),
                      ),
                    );
                  } else {
                    // Show a snackbar indicating that the player has already played
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("You have already played the game."),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                }
              });
            }
          },
          child: Text("Play"),
        ),
      ),
    ),
    Expanded(
      child: Container(
        color: const Color.fromARGB(255, 181, 34, 23),
        child: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () async {
  final currentRoom = userData!['currentRoom'];
  final currentPool = userData!['currentPool'];

  final roomRef = FirebaseFirestore.instance.collection('$currentPool' + '_rooms').doc(currentRoom);

  final playerDataQuery = await roomRef.collection('player_data').where('game_over', isEqualTo: true).get();
  final totalPool = await roomRef.get().then((roomDoc) => roomDoc.data()?['total_pool']);

  final playerDataList = playerDataQuery.docs.map((doc) => doc.data()).toList();
  playerDataList.sort((a, b) => b['score'].compareTo(a['score']));

  if (playerDataList.isNotEmpty) {
    // Calculate shares for top 3 players
    final topPlayers = playerDataList.take(3).toList();

    final firstPlayerShare = (totalPool! * 0.5).toInt();
    final secondPlayerShare = (totalPool! * 0.3).toInt();
    final thirdPlayerShare = (totalPool! * 0.2).toInt();

    // Show a popup with the top 3 players, their scores, and shares
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Top Players and Shares'),
          content: Column(
            children: <Widget>[
              Text('1st Place: ${topPlayers[0]['handle']}, Score: ${topPlayers[0]['score']}, Share: $firstPlayerShare'),
              Text('2nd Place: ${topPlayers[1]['handle']}, Score: ${topPlayers[1]['score']}, Share: $secondPlayerShare'),
              Text('3rd Place: ${topPlayers[2]['handle']}, Score: ${topPlayers[2]['score']}, Share: $thirdPlayerShare'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
    // Show a message if no players with 'game_over' set to true are found
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("No players with 'game_over' set to true."),
        duration: Duration(seconds: 3),
      ),
    );
  }
},

          child: Text("Result"),
        ),
      ),
    ),
  ],
)

        ],
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
