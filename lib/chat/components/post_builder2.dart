import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostBuilder2 extends StatefulWidget {
  @override
  State<PostBuilder2> createState() => _PostBuilder2State();
}

class _PostBuilder2State extends State<PostBuilder2> {
  final Stream<QuerySnapshot> _postStream = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('createdAt')
      //タスクの表示自体に個人の特定をしたかったらこれをつける。
      // .where('posterId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    //TODO 1 まず投稿を、posterIdをつけて保存する。
    return StreamBuilder(
        stream: _postStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('エラーが発生しました');
          } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Text('ドキュメントがありません');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];

            return ListView(
              //TODO質問　ここの部分。
              children: docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                //TODO post名前を表示させるために、ここでとっておく。
                String post = data['text']; //TODO あかん書き方。
                String userId = data['posterId'];
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
