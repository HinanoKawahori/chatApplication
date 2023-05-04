import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import 'circlePhoto.dart';

class ChatTile extends StatelessWidget {
  ChatTile({
    super.key,
    required this.postText,
    required this.userName,
    //TODO imageUrlがいるので、ここにつける。
    required this.imageUrl,
  });
  final String imageUrl;
  final String postText;
  final String userName;
  final auth.User? user = auth.FirebaseAuth.instance.currentUser;
  final _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      //TODO エラーが出た原因。
      //expandedがcirclephotoにまで届いていなかった？？

      //child: Row(children: [
      child: Card(
        child: ListTile(
          leading: CirclePhoto(
            imageUrl: imageUrl,
            //TODO radiusでサイズを指定しないとエラーになる。
            radius: 30,
          ),
          title: Text(postText), // Display the task name
          subtitle: Text(userName), // Display the user name as subtitle
        ),
      ),
      // ]),
    );
  }
}
