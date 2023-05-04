import 'package:chatapplication/chat/components/parts/chatTile.dart';
import 'package:chatapplication/data_models/post/post.dart';
import 'package:chatapplication/data_models/user/user.dart';
import 'package:chatapplication/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
            .collection('posts')
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
            //asyncsnapshotをdataでquerysnapshotに戻す。その後、querysnapshotでリストにする。
            List docs = snapshot.data?.docs ?? [];

            return ListView(
              //docsListから、docを一つずつとる。
              children: docs.map((doc) {
                //QDS（doc)を使える形にする。
                Map<String, dynamic> postMapData = doc.data();
                //{QDS}をpostの形にする。
                Post postData = Post.fromJson(postMapData);
                // Map<String, dynamic> data = doc.data();
                //TODO ここで初めてtext,posterIdなどのプロパティが使える。
                //TODO ここで、タスク名とuserIdを結びつける。
                String postText = postData.text;
                String userId = postData.posterId;

                //ユーザーIDを結びつける。
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      if (snap.data!.exists) {
                        //List document = snap.data!.data() ?? [];
                        Map<String, dynamic> userMapData =
                            snap.data!.data() ?? {};
                        //Map<String, dynamic> userMapData = doc.data();
                        User userData = User.fromJson(userMapData);
                        String userName = userData.userName;
                        String imageUrl = userData.imageUrl;

                        //追加したい情報!!!!!!
                        return ChatTile(
                          postText: postText,
                          userName: userName,
                          imageUrl: imageUrl,
                        );
                      } else {
                        return ChatTile(
                          postText: postText,
                          userName: 'User not found',
                          imageUrl: '',
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Card(
                          child: ListTile(
                        title: Text(postText), // Display the task name
                        subtitle: Text(
                            'Error: ${snapshot.error}'), // Display the error message
                      ));
                    } else {
                      CircularProgressIndicator();

                      return Card(
                          child: ListTile(
                        title: Text(postText), // Display the task name
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
