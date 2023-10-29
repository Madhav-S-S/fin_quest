import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String customerId;

  Home({required this.customerId, Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int m_coins = 0;
  String handle = 'unknown';

  @override
  void initState() {
    super.initState();
    // Listen to changes in the 'm_coins' field in Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.customerId)
        .snapshots()
        .listen((document) {
      if (document.exists) {
        setState(() {
          m_coins = document.data()!['m_coins'];
        });
      }
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.customerId)
        .snapshots()
        .listen((document) {
      if (document.exists) {
        setState(() {
          handle = document.data()!['handle'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(255, 0, 0, 1),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Game Zone",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontFamily: "Poppins"),
        ),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        color: Color.fromRGBO(255, 0, 0, 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/m_coins.png',
                            width: 40,
                            height: 40,
                          ),
                          Text(
                            '  $m_coins',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Withdraw',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/dp.jpg'),
                      ),
                      Text(
                        "$handle",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Poppins"),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
             Container(
  width: MediaQuery.of(context).size.width,
  height: MediaQuery.of(context).size.height, // Set the height to occupy the entire screen height
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // Round the top edges
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Add the "Newly Arrived Games" text here
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 30),
          child: Text(
            "Newly Arrived Games",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              fontFamily: "poppins",
            ),
          ),
        ),
      ),
      // Horizontal scrolling for game cards
      Container(
        height: MediaQuery.of(context).size.height * 0.4, // Adjust the height as needed
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(16),
          children: [
            _buildGameCard(
              gameName: "Snake",
              imageURL: "assets/images/snake.webp",
            ),
            _buildGameCard(
              gameName: "Financial Quiz",
              imageURL: "assets/images/bank quiz.jpg",
            ),
            // _buildGameCard(
            //   gameName: "Game 3",
            //   imageURL: "assets/images/game3.jpg",
            // ),
            // Add more game/app cards as needed
          ],
        ),
      ),
    ],
  ),
),



            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard({required String gameName, required String imageURL}) {
    return Container(
      margin: EdgeInsets.only(right: 14),
      width: 180, // Adjust the card width as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
            child: Image.asset(
              imageURL,
              width: 140,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(height: 8),
          Text(
            gameName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle button press for the game/app
            },
            child: Text("Play"),
          ),
        ],
      ),
    );
  }
}
