import 'package:chatapplication/data_models/post/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostBuilder extends StatelessWidget {
  final _db = FirebaseFirestore.instance;
  //firebaseからデータの取得。

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<QuerySnapshot>(
    //   stream: _db.collection('posts').orderBy('createdAt').snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text('Error: ${snapshot.error}');
    //     }
    //     if (!snapshot.hasData) {
    //       return Text('Loading...');
    //     }

    //     final docs = snapshot.data?.docs ?? [];

    //     //TODO  ここの書き方復習
    //     return ListView.builder(
    //       itemCount: docs.length,
    //       itemBuilder: (context, index) {
    //         final post = docs[index].data();
    //         return StreamBuilder<DocumentSnapshot>(
    //           stream: _db.collection('users').doc('userId').snapshots(),
    //           builder: (BuildContext context,
    //               AsyncSnapshot<DocumentSnapshot> snapshot) {
    //             if (snapshot.hasError) {
    //               return Text('Error: ${snapshot.error}');
    //             }
    //             if (!snapshot.hasData) {
    //               return Text('Loading...');
    //             }
    //             final poster = snapshot.data!.data();

    //             return Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(post?.text), //TODO post.textがえらーになるのなんでええ
    //                 Text(poster?.text), //この２つ、エラーになるのなんでえええ
    //                 Divider(),
    //               ],
    //             );
    //           },
    //         );
    //       },
    //     );
    //   },
    // );

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final post =
                Post.fromJson(docs[index].data() as Map<String, dynamic>);
            final userData = FirebaseFirestore.instance
                .collection('users')
                .doc(post.posterId)
                .get();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.text ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  'Posted by: ${userData.use ?? 'Anonymous'}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14.0,
                  ),
                ),
                Divider(),
              ],
            );
          },
        );
      },
    );
  }
}
