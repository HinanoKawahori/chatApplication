import 'package:chatapplication/data_models/post/post.dart';
import 'package:chatapplication/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PostBuilder2 extends StatefulWidget {
  @override
  State<PostBuilder2> createState() => _PostBuilder2State();
}

class _PostBuilder2State extends State<PostBuilder2> {
  @override
  Widget build(BuildContext context) {
    //TODO 1 まず投稿を、posterIdをつけて保存する。
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('post')
            .orderBy('createdAt')
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return const Text('エラーが発生しました');
          } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Text('ドキュメントがありません');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            List docs = snapshot.data?.docs ?? [];

            return ListView(
              children: docs.map((doc) {
                //TODO質問　ここの書き方
                Map<String, dynamic> postMapData = doc.data();
                Post postData = Post.fromJson(postMapData);
                // Map<String, dynamic> data = doc.data();

                //TODO post名前を表示させるために、ここでとっておく。
                String postText = postData.text;
                String userId = postData.posterId;
                //TODO ここで、タスク名とuserIdを結びつける。

                //ユーザーIDを結びつける。
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      //ここにuserIdをいれなきゃだめだ。
                      .doc(userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.exists) {
                        //userDataをとってくる。

                        final userData =
                            snapshot.data?.data() as Map<String, dynamic>;
                        //userNameを定義する
                        String userName = userData['userName']; //追加したい情報!!!!!!
                        return Card(
                          child: ListTile(
                            title: Text('$post'), // Display the task name
                            subtitle: Text(
                                '$userName'), // Display the user name as subtitle
                          ),
                        );
                      } else {
                        return Card(
                            child: ListTile(
                          title: Text('$post'), // Display the task name
                          subtitle: Text(
                              'User not found'), // Display a default text if user data does not exist
                        ));
                      }
                    } else if (snapshot.hasError) {
                      return Card(
                          child: ListTile(
                        title: Text('$post'), // Display the task name
                        subtitle: Text(
                            'Error: ${snapshot.error}'), // Display the error message
                      ));
                    } else {
                      CircularProgressIndicator();

                      return Card(
                          child: ListTile(
                        title: Text('$post'), // Display the task name
                        // subtitle: Text('投稿者: $userName'),
                        // Display a progress indicator while data is being fetched
                      ));
                    }
                  },
                );
              }).toList(),
            );
          }
        });
  }
}
