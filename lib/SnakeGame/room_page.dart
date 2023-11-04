import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_quest/Financial%20Quiz/quiz.dart';
import 'package:fin_quest/SnakeGame/snake_game.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  final String customerId;
  final String gameName;
  RoomPage({required this.customerId,required this.gameName, Key? key}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  Map<String, dynamic>? userData; 

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
      body: Container(
        width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/room_menu_bg.jpg'), 
          fit: BoxFit.cover,
        ),
      ),
        child: Column(
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
                  userData = userSnapshot.data?.data(); 
      
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
                          return PostCardWidget(playerData: player);
                        },
                      );
                    },
                  );
                },
              ),
            ),
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
              if (userData != null) { 
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
                      if(widget.gameName == 'Snake'){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SnakeGame(customerId: widget.customerId),
                        ),
                      );
                      }else if(widget.gameName == 'Financial Quiz'){
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPage(customerId: widget.customerId),
                        ),
                      );}
                    } else {
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
        final roomDoc = await roomRef.get();
        final resultPublished = roomDoc.data()?['result_published'];
        final playerDataQuery = await roomRef.collection('player_data').where('game_over', isEqualTo: true).get();
        final totalPool = await roomRef.get().then((roomDoc) => roomDoc.data()?['total_pool']);
      
        final playerDataList = playerDataQuery.docs.map((doc) => doc.data()).toList();
        playerDataList.sort((a, b) => b['score'].compareTo(a['score']));
      
        if (playerDataList.isNotEmpty) {
          final topPlayers = playerDataList.take(3).toList();
      
          final firstPlayerShare = (totalPool! * 0.5).toInt();
          final secondPlayerShare = (totalPool! * 0.3).toInt();
          final thirdPlayerShare = (totalPool! * 0.2).toInt();
          if(resultPublished == false){
        FirebaseFirestore.instance.collection('users').doc(topPlayers[0]['customerId']).update({'m_coins': FieldValue.increment(firstPlayerShare),});
        FirebaseFirestore.instance.collection('users').doc(topPlayers[1]['customerId']).update({'m_coins': FieldValue.increment(secondPlayerShare),});
        FirebaseFirestore.instance.collection('users').doc(topPlayers[2]['customerId']).update({'m_coins': FieldValue.increment(thirdPlayerShare),});
        await roomRef.update({'result_published': true});
          }
          AlertDialog alertDialog = AlertDialog(
        backgroundColor: Colors.red,
        title: Text(
          'Top Players and Shares',
          style: TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'Roboto',
        fontSize: 20,
        fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          children: [
        Column(
          children: [
            Text(
              '1st Place',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 28,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              topPlayers[0]['handle'],
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              'Score: ${topPlayers[0]['score']}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              '$firstPlayerShare Coins Gained..!',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              '2nd Place',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 28,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              topPlayers[1]['handle'],
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              'Score: ${topPlayers[1]['score']}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              '$secondPlayerShare Coins Gained..!',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              '3rd Place',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 28,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              topPlayers[2]['handle'],
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              'Score: ${topPlayers[2]['score']}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              '$thirdPlayerShare Coins Gained..!',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white, 
        ),
        child: Text(
          'Close',
          style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 18,
        color: Colors.black, 
          ),
        ),
      ),
      
        ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      );
      
      showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        },
      );
      
      
      
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Wait for other players to complete the game."),
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
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50),
  ),
  child: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 211, 17, 192),
        Color.fromARGB(255, 47, 0, 255),
      ],
    ),
    borderRadius: BorderRadius.circular(20.0), 
  ),
  child: ListTile(
    title: Text(playerData['handle'].toString(), style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
    subtitle: Text(playerData['score'].toString(), style: TextStyle(color: Colors.white)),
    tileColor: const Color.fromARGB(0, 255, 255, 255), 
    contentPadding: const EdgeInsets.all(16.0),
  ),
)

);




  }
}
