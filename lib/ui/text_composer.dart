import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  final Function(String) sendMessage;
  final Function(File) sendPicture;

  TextComposer({ this.sendMessage, this.sendPicture });

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  final _textController = TextEditingController();

  _sendMessage(String text) {
    setState(() {
      widget.sendMessage(text);
      _textController.clear();
      _isComposing = false;
    });
  }

  _openImagePicker(ImageSource source) async{
    final file = await ImagePicker.pickImage(source: source);

    if (file != null){
      widget.sendPicture(file);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: () {
              showDialog(
                  context: context,
                  child: AlertDialog(
                      title: Text('Enviar imagem...'),
                      content: Container(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.camera),
                                        onPressed: (){
                                          _openImagePicker(ImageSource.camera);
                                        },
                                      ),
                                      Text('Câmera')
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.insert_drive_file),
                                        onPressed: (){
                                          _openImagePicker(ImageSource.gallery);
                                        },
                                      ),
                                      Text('Galeria')
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: RaisedButton(
                                  color: Colors.redAccent,
                                  child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ]),
                      )));
            },
          ),
          Expanded(
              child: TextField(
            controller: _textController,
            decoration:
                InputDecoration.collapsed(hintText: 'Enviar uma mensagem'),
            onChanged: (text) {
              setState(() {
                _isComposing = text.isNotEmpty;
              });
            },
            onSubmitted: _sendMessage,
          )),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing
                ? () {
                    _sendMessage(_textController.text);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
