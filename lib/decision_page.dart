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
        backgroundColor: Colors.red,
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
              SizedBox(height: 10),
              Text(
                "Select an Option",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Code to create a new room goes here
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, // Set button color to transparent
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: Size(300, 150), // Set the button size
                ),
                child: Text(
                  "Create New Room",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Poppins",
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Code to navigate to "My Room" goes here
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, // Set button color to transparent
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
                    color: Colors.white,
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
