import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.purple,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   'assets/images/logo.png',
                //   width: 150,
                //   height: 150,
                // ),
                SizedBox(height: 20),
                Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
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
                      Navigator.pushNamed(context, '/home');
                    },
                    child: Text(
                      'Login',
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
    );
  }
  Future<void> login() async {
  // Get the customer ID from the text field.
  String customerId = _emailController.text;

  // Create a reference to the collection 'user'.
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Check if the document with the given customer ID exists.
  DocumentSnapshot snapshot = await users.doc(customerId).get();
  if (snapshot.exists) {
    // Navigate to the home page.
    Navigator.pushNamed(context, '/home');
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
