import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Home extends StatefulWidget {
  final String customerId;

  Home({required this.customerId, Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int m_coins = 0;

  @override
  void initState() {
    super.initState();
    // Get the m_coins value from Firebase
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.customerId)
        .get()
        .then((document) {
      setState(() {
        m_coins = document['m_coins'];
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      
      appBar: AppBar(
        //make the backbutton disappear
        automaticallyImplyLeading: false,
        //create a dashboard app bar
        backgroundColor: Color.fromRGBO(255, 0, 0, 1),
        //remove the shadow of the app bar
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
          // Add a gear button
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
                          FutureBuilder<DocumentSnapshot>(
                            builder: ((context,snapshot){
                              if (snapshot.connectionState == ConnectionState.done){
                                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                return Text(
                                  '  ${data['m_coins']}',
                                );
                              }
                              return Text(
                                'Loading...',
                              );
                            })
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //white button with text 'withdraw'
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
                      //circular avatar
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/dp.jpg')),
                      Text("king_slayer",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Poppins")),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "          customerId: ${widget.customerId}",
                      style: TextStyle(
                        color: Color.fromARGB(120, 0, 0, 0),
                        fontSize: 10,
                        fontFamily: "Poppins"),
                    ),
                  ),
                ],
              )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
