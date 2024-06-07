// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chatroom_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(19, 19, 19, 1),
        body: _userList()
    );
  }

  Widget _userList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          }

          return ListView(
            children: snapshot.data!.docs.map<Widget>((doc) =>
                _userListItem(doc)).toList(),
          );
        });
  }

  Widget _userListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser?.email != data['email']) {
      return ListTile(
        title: Text(data['email'], style: GoogleFonts.poppins(color: Colors.white),),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              ChatRoomPage(ReceiverUserEmail: data['email'],
                ReceiverUserId: data['uid'],)));
        },
      );
    } else {
      return Container();
    }
  }
}
