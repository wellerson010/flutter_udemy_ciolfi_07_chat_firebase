import 'package:flutter/material.dart';

enum _Padding {
  right,
  left
}

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool mine;

  ChatMessage(this.data, this.mine);

  Widget _buildContentMessage(CrossAxisAlignment alignment, TextAlign textAlign){
    return Expanded(
      child: Column(
        crossAxisAlignment: alignment,
        children: <Widget>[
          (data['pictureUrl'] != null)?Image.network(data['pictureUrl'], width: 250,):Text(data['text'], style: TextStyle(fontSize: 16),  textAlign: textAlign),
          Text(data['senderName'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500), textAlign: textAlign,)
        ],
      ),
    );
  }

  Widget _buildPhoto(_Padding _padding){
    EdgeInsets edge = (_padding == _Padding.left)?EdgeInsets.only(left: 16):EdgeInsets.only(right: 16);

    return Padding(
        padding: edge,
        child:CircleAvatar(
          backgroundImage: NetworkImage(data['senderPhotoUrl']),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> childrenRow = [];

    if (!mine){
      childrenRow.add(_buildPhoto(_Padding.right));
    }

    CrossAxisAlignment alignmentContent = mine?CrossAxisAlignment.end:CrossAxisAlignment.start;
    TextAlign textAlign = mine?TextAlign.end:TextAlign.start;

    childrenRow.add(_buildContentMessage(alignmentContent, textAlign));

    if (mine){
      childrenRow.add(_buildPhoto(_Padding.left));
    }

    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: childrenRow
      ),
    );
  }
}