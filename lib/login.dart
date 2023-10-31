import 'package:fin_quest/create_player.dart';
import 'package:fin_quest/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final id_controller = TextEditingController();
  static final keyController = TextEditingController();
  static final incrementController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red,
              Colors.purple,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), // Add padding from sides
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter, // Align text to the top
                    child: Text(
                      'Mirror+ Connecting to GameZone...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  TextField(
                    controller: id_controller,
                    decoration: InputDecoration(
                      hintText: 'Customer ID',
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: keyController,
                    decoration: InputDecoration(
                      hintText: 'Encryption Key',
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // validate using firebase
                        login();
                      },
                      child: Text(
                        'Connect',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateUserPage(),
              ),
            );
                      },
                      child: Text(
                        'Create New Player',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 130, // Set the desired width
                    child: TextField(
                      controller: incrementController,
                      decoration: InputDecoration(
                        hintText: 'Mirror Coin ++',
                        hintStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      try {
                        // Increment the coin count in the database.
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(id_controller.text)
                            .update({'m_coins': FieldValue.increment(int.parse(incrementController.text))});

                        // Show a success message using a SnackBar.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Coins incremented successfully'),
                            backgroundColor: Colors.green, // Customize the SnackBar's background color
                          ),
                        );
                      } catch (e) {
                        // Handle any errors that occurred during the database operation.
                        print('Error: $e');
                      }
                    },
                    child: Container(
                      width: 50, // Adjust the size as needed
                      height: 50, // Adjust the size as needed
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 0, 0), // Set the background color of the button
                        shape: BoxShape.circle, // Create a circular shape
                      ),
                      child: Center(
                        child: Text(
                          '+',
                          style: TextStyle(
                            color: Colors.white, // Set the text color
                            fontSize: 24, // Set the text size
                          ),
                        ),
                      ),
                    ),
                  )


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
  // Get the customer ID from the text field.
  String customerId = id_controller.text;
  String key = keyController.text; // Assuming you have a keyController.

  // Create a reference to the collection 'users'.
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Check if the document with the given customer ID exists.
  DocumentSnapshot snapshot = await users.doc(customerId).get();

  if (snapshot.exists) {
    // Check if the 'key' field in the document matches the value from keyController.
    final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  
  if (data != null && data['key'] == key) {
      // Navigate to the home page.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(customerId: customerId),
        ),
      );
    } else {
      // Show an error message if 'key' doesn't match.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid key for the customer ID.'),
        ),
      );
    }
  } else {
    // Show an error message if the customer ID does not exist.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The customer ID does not exist.'),
      ),
    );
  }
}

}
