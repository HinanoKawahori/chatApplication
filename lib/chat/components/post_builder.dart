import 'package:chatapplication/data_models/post/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostBuilder extends StatelessWidget {
  final _db = FirebaseFirestore.instance;
  //firebaseからデータの取得。

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('Loading...');
        }

        final docs = snapshot.data?.docs ?? [];

        //TODO  ここの書き方復習
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final post = docs[index].data();
            return StreamBuilder<DocumentSnapshot>(
              stream: _db.collection('users').doc('userId').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Text('Loading...');
                }
                //TODO　これでデータを持ってくる。
                //final userName = snapshot.data!.data();
                final post =
                    Post.fromJson(docs[index].data() as Map<String, dynamic>);

                // //TODO 名前の取り出し方。
                // final data = userDataSnapshot.data() as Map<String, dynamic>;
                // final userName = data['userName'] as String;
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(post.posterId)
                      .snapshots(),
                  //ここで、usersのユーザーIDと繋げる。
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    final userData =
                        snapshot.data?.data() as Map<String, dynamic>;

                    if (userData == null || userData['userName'] == null) {
                      return Text('Anonymous');
                    }
                    final userName = userData['userName'] as String;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.text ?? '',
                        ),
                        Text(
                          'Posted by: ${userName ?? 'Anonymous'}',
                        ),
                        Divider(),
                      ],
                    );
                  },
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.text), //TODO post.textがえらーになるのなんでええ
                    Text('name'), //この２つ、エラーになるのなんでえええ
                    Divider(),
                  ],
                );
              },
            );
          },
        );
      },
    );

    // return StreamBuilder<QuerySnapshot>(
    //     stream: FirebaseFirestore.instance.collection('posts').snapshots(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return CircularProgressIndicator();
    //       }
    //       final docs = snapshot.data!.docs;

    //       return ListView.builder(
    //         itemCount: docs.length,
    //         itemBuilder: (context, index) {
    //           final post =
    //               Post.fromJson(docs[index].data() as Map<String, dynamic>);

    //           final UserData = FirebaseFirestore.instance
    //               .collection('users')
    //               .doc(post.posterId)
    //               .get();

    //           return StreamBuilder<DocumentSnapshot>(
    //             stream: _db.collection('users').doc('userId').snapshots(),
    //             builder: (BuildContext context,
    //                 AsyncSnapshot<DocumentSnapshot> snapshot) {
    //               if (snapshot.hasError) {
    //                 return Text('Error: ${snapshot.error}');
    //               }
    //               if (!snapshot.hasData) {
    //                 return Text('Loading...');
    //               }
    //               //TODO　これでデータを持ってくる。

    //               final post =
    //                   Post.fromJson(docs[index].data() as Map<String, dynamic>);
    //               final userData = FirebaseFirestore.instance
    //                   .collection('users')
    //                   .doc(post.posterId)
    //                   .get();
    //               return Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(
    //                     post.text ?? '',
    //                   ),
    //                   Text(
    //                     'Posted by: ${userData ?? 'Anonymous'}',
    //                   ),
    //                   Divider(),
    //                 ],
    //               );
    //             },
    //           );
    //         },
    //       );
    //     });
  }
}
