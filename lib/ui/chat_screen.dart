import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'text_composer.dart';
import 'chat_message.dart';
import '../service/firebase_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreen createState()=>_ChatScreen();
}

class _ChatScreen extends State<ChatScreen>{
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _messageStatus(BuildContext context, MessageStatus status){
    if (status == MessageStatus.loginProblem){
      final snackbar = SnackBar(
        content: Text('Não foi possível fazer o login'),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('ChatApp'),
        actions: <Widget>[
          Builder(
            builder: (context){
              return IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: (){
                  signOut();

                  final snackbar = SnackBar(
                    content: Text('Você saiu com sucoesso!')
                  );

                  Scaffold.of(context).showSnackBar(snackbar);
                },
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance.collection('message').orderBy('time', descending: true).snapshots(),
              builder: (context, snapshot){
                switch (snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    );
                  default:
                    List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList();

                    return ListView.builder(
                      itemBuilder: (context, index){
                        DocumentSnapshot document = documents[index];
                        return ChatMessage(document.data, false);
                      },
                      itemCount: documents.length,
                    );
                }
              },
            ),
          ),
          Builder(
            builder: (context){
              return TextComposer(
                sendMessage: (text) async{
                  final message = await sendMessage(text: text);
                  _messageStatus(context, message);
                },
                sendPicture: (File file) async{
                  final message = await sendPicture(file);
                  _messageStatus(context, message);
                },
              );
            },
          )
        ],
      ),
    );
  }
}