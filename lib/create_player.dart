import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController customerIdController = TextEditingController();
  final TextEditingController handleController = TextEditingController();
  final TextEditingController keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 17, 0),
        title: Text('Create Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: customerIdController,
              decoration: InputDecoration(labelText: 'Customer ID'),
            ),
            TextField(
              controller: handleController,
              decoration: InputDecoration(labelText: 'Handle'),
            ),
            TextField(
              controller: keyController,
              decoration: InputDecoration(labelText: 'Encryption Key'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: createUser,
              child: Text('Create User'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
    Future<void> createUser() async {
    final String customerId = customerIdController.text;
    final String handle = handleController.text;
    final String key = keyController.text;

    if (customerId.isNotEmpty && handle.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(customerId).set({
        'currentPool': null, // You can set initial values here
        'currentRoom': null,
        'handle': handle,
        'm_coins': 0, // You can set the initial number of coins here
        'key': key,
      });

      //show succes message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User created successfully.'),
        ),
      );
      //go to login page
      Navigator.pop(context);
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all the fields.'),
        ),
      );
    }
  }
}