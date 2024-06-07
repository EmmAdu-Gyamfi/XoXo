import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:xoxo/services/chat_service.dart';
import 'package:xoxo/utils/colors.dart';

class ChatRoomPage extends StatefulWidget {
  final String ReceiverUserEmail;
  final String ReceiverUserId;

  const ChatRoomPage({super.key, required this.ReceiverUserEmail, required this.ReceiverUserId});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  DateTime? _lastMessageDate;
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.ReceiverUserId, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        // resizeToAvoidBottomInset: true,
      // backgroundColor: Color.fromRGBO(19, 19, 19, 1),
      appBar: AppBar(
        title: Text("${widget.ReceiverUserEmail}", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),),
        backgroundColor: Color.fromRGBO(19, 19, 19, 1),
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              height: screenHeight*0.06,
              width: screenWidth*0.1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: Text("${widget.ReceiverUserEmail[0].toUpperCase()}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(19, 19, 19, 1),
        
                ),
                child: Image.asset("assets/png/doodle.png", fit: BoxFit.cover,)
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.83),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildMessageList()),
                  _buildMessageInput(),
        
                ],
        
        
              ),
            )
        
          ],
        ),
      )
    );
  }

  Widget _buildMessageInput() {
    return Container(
      color: Color.fromRGBO(19, 19, 19, 1),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, top: 6),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:20.0),
                child: Container(
                  padding: EdgeInsets.only(top: 0),
                  child: TextField(
                    controller: _messageController,
                    obscureText: false,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: null, // This allows the TextField to expand vertically
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter a message...",
                      hintStyle: GoogleFonts.poppins(color: Colors.white),
                      fillColor: Color.fromRGBO(44, 44, 44, 1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: (){
                sendMessage();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 16),
                child: Container(
                  height: 50,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Icon(CupertinoIcons.paperplane_fill),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Parse the timestamp into DateTime
    DateTime timestamp = (data['timestamp'] as Timestamp).toDate();

    // Format the DateTime to display time with AM or PM
    String formattedTime = DateFormat.jm().format(timestamp);
    var alignment = (data['senderId']) == _firebaseAuth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft;

    // Check if the date of the message is different from the last message
    bool showDate = _lastMessageDate == null || timestamp.day != _lastMessageDate!.day;
    _lastMessageDate = timestamp;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: (data['senderId']) == _firebaseAuth.currentUser!.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showDate) // Show date if it's different from the last message
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    DateFormat('EEEE, MMM d, yyyy').format(timestamp), // Format the date as desired
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ),
          Container(
            alignment: alignment,
            // color: Colors.blue,
            child: (data['senderId']) == _firebaseAuth.currentUser!.uid ? BubbleSpecialThree(
            text: data['message'],
            color: AppColors.primary,
            tail: true,
            textStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          
            ),
          ) : BubbleSpecialThree(
              text: data['message'],
              color: Color.fromRGBO(44, 44, 44, 1),
              tail: true,
              isSender: false,
              textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 17
              ),
            ),
              ),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5),
            child: Text(formattedTime.toString(), style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),),
          )
        ],
      )
    );
  }

  Widget  _buildMessageList(){
    return StreamBuilder(stream: _chatService.getMessages(widget.ReceiverUserId, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text("error${snapshot.error}");
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return Text("loading");
          }

          return ListView(
            reverse: true,
            children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
          );
        });
  }
}
