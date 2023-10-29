import 'package:fin_quest/SnakeGame/room_page.dart';
import 'package:fin_quest/pool_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class decisionPage extends StatefulWidget {
  final String customerId;
  decisionPage({required this.customerId, Key? key}) : super(key: key);

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
          image: AssetImage('assets/images/room_menu_bg.jpg'), // Set the background image
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
              SizedBox(height: 150),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PoolSelectionPage(customerId: widget.customerId),
              ),
            );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white.withOpacity(0.3), // Set a slightly transparent white background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: Size(300, 150), // Set the button size
                ),
                child: Text(
                  "Join Room",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Poppins",
                    color: Colors.white, // Text color
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => roomPage(),
              ),
            );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white.withOpacity(0.3), // Set a slightly transparent white background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: Size(300, 150), // Set the button size
                ),
                child: Text(
                  "My Room",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Poppins",
                    color: Colors.white, // Text color
                  ),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
  ],
),

    );
  }
}
