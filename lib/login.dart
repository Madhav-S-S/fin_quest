import 'package:fin_quest/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final id_controller = TextEditingController();

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
                      'Bank Connecting to GameZone...',
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
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
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
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
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

    // Create a reference to the collection 'user'.
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Check if the document with the given customer ID exists.
    DocumentSnapshot snapshot = await users.doc(customerId).get();
    if (snapshot.exists) {
      // Navigate to the home page.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(customerId: customerId),
        ),
      );
    } else {
      // Show an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The customer ID does not exist.'),
        ),
      );
    }
  }
}
