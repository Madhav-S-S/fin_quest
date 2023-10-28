import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
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
          icon: const Icon(Icons.logout),
          onPressed: () {},
        ),
        actions: [
          // Add a gear button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Color.fromRGBO(255, 0, 0, 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
