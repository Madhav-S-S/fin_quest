import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class roomCard extends StatefulWidget {
  final snap;
  const roomCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<roomCard> createState() => _roomCardState();
}

class _roomCardState extends State<roomCard> {
  final database = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
        // boundary needed for web
        constraints: const BoxConstraints(
          maxWidth: 700,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        //border color set
        decoration: BoxDecoration(
          //make the border circular
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
          ),
          // IMAGE SECTION OF THE POST
          // LIKE, COMMENT SECTION OF THE POST
          //date published of the post
        ]));
  }
}
