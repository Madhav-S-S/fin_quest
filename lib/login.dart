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
              padding: const EdgeInsets.symmetric(horizontal: 20), 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter, 
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
                    width: 105,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
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
                    width: 130, 
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
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(id_controller.text)
                            .update({'m_coins': FieldValue.increment(int.parse(incrementController.text))});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Coins incremented successfully'),
                            backgroundColor: Colors.green, 
                          ),
                        );
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                    child: Container(
                      width: 50, 
                      height: 50, 
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 0, 0),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '+',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 24, 
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

  String customerId = id_controller.text;
  String key = keyController.text; 
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentSnapshot snapshot = await users.doc(customerId).get();

  if (snapshot.exists) {
    final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  
  if (data != null && data['key'] == key) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(customerId: customerId),
        ),
      );
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid key for the customer ID.'),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The customer ID does not exist.'),
      ),
    );
  }
}

}
