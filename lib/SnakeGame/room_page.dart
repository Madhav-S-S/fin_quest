import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_quest/SnakeGame/room_card.dart';
import 'package:flutter/material.dart';

class roomPage extends StatefulWidget {
  const roomPage({Key? key}) : super(key: key);

  @override
  _roomPageState createState() => _roomPageState();
}

class _roomPageState extends State<roomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),),
        //add an icon to right side of appbar
        actions: [
          IconButton(
            //on pressed function to navigate to the draft page of general complaints
            onPressed: () {
            },
            //icon for a pen to write a new complaint
            icon: Icon(Icons.settings),
          ),
        ],
      backgroundColor: Color.fromRGBO(255, 0, 0, 1),
        centerTitle: true,
        title: const Text(
          "My Room",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal,fontFamily: "Poppins"),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(0, 28, 46, 1),
        child: Container(
          decoration: BoxDecoration(
                //make border radius circular only at the top
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(0, 28, 46, 1),
                  Color.fromRGBO(0, 28, 46, 1),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: StreamBuilder(
            //order the complaints by date published
            stream: FirebaseFirestore.instance.collection('gen_complaints').orderBy('upvotes',descending: true).snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => roomCard(
                  snap : snapshot.data!.docs[index].data(),
                ),
             
              );
            },
          ),
        ),
      ),
    );
  }
}
//create a home page with reddit feed like design
