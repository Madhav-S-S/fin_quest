

import 'package:fin_quest/login.dart';
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
        backgroundColor: Color.fromRGBO(0, 28, 46, 1),
        // leading: null,
        // automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "STUDENT HOME",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontFamily: "Poppins"),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(0, 28, 46, 1),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                //make border radius circular only at the top
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),),
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Text("Select the Complaint Type",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins")),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home()));
                    },
                    child: Container(
                        height: 150,
                        width: 1000,
                        //make the container half transparent
                        child: Center(
                          child: Text(
                            "GENERAL",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Poppins",
                                color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                          //make the color of the container transparent
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home()));
                    },
                    child: Container(
                        height: 150,
                        width: 1000,
                        child: Center(
                          child: Text(
                            "OPEN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Poppins",
                                color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home()));
                    },
                    child: Container(
                        height: 150,
                        width: 1000,
                        child: Center(
                          child: Text(
                            "PERSONAL",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Poppins",
                                color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  //increase the width of the MaterialButton below
                  
                ],
              ),
            ))),
      ),
    );
  }
}
