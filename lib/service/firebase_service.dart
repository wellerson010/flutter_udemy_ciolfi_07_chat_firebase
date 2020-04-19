import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseUser _currentUser;
GoogleSignIn _googleSignIn;

enum MessageStatus {
  loginProblem,
  ok
}

void signOut(){
  FirebaseAuth.instance.signOut();

  if (_googleSignIn != null) {
    _googleSignIn.signOut();
  }
}

Future<FirebaseUser> getUser() async{
  if (_currentUser != null){
    print('não nulo');
    return _currentUser;
  }

  try{
    _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount signIn = await _googleSignIn.signIn();
    final authentication = await signIn.authentication;

    final credential = GoogleAuthProvider.getCredential(idToken: authentication.idToken, accessToken: authentication.accessToken);
    final authResult = await FirebaseAuth.instance.signInWithCredential(credential);

    _currentUser = authResult.user;

    return _currentUser;
  }
  catch (e){
    print(e);
    return null;
  }

}

Future<MessageStatus> sendMessage({String text, String pictureUrl}) async{
  final user = await getUser();

  if (user == null){
    return MessageStatus.loginProblem;
  }

  Map<String, dynamic> content = {};

  if (text != null){
    content['text'] = text;
  }

  if (pictureUrl != null){
    content['pictureUrl'] = pictureUrl;
  }

  content['senderName'] = user.displayName;
  content['senderPhotoUrl'] = user.photoUrl;
  content['uid'] = user.uid;
  content['time'] = Timestamp.now();
  
  Firestore.instance.collection('message').add(content);

  return MessageStatus.ok;
}

Future<MessageStatus> sendPicture(File file) async {
  StorageUploadTask task = FirebaseStorage.instance
      .ref()
      .child(DateTime.now().millisecondsSinceEpoch.toString())
      .putFile(file);

  StorageTaskSnapshot snapshot = await task.onComplete;
  String url = await snapshot.ref.getDownloadURL();

  return sendMessage(pictureUrl: url);
}
