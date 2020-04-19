import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ui/chat_screen.dart';

void main(){
  runApp(MaterialApp(
    home: ChatScreen(),
    theme: ThemeData(
      iconTheme: IconThemeData(
        color: Colors.blue
      )
    ),
  ));
}

