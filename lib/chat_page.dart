import 'package:chatapplication/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャット'),
      ),
<<<<<<< HEAD
      body: Column(
        children: [
          //child1, streambuilder
          Expanded(
            child: StreamBuilder<QuerySnapshot<Post>>(
              // stream プロパティに snapshots() を与えると、コレクションの中のドキュメントをリアルタイムで監視することができます。
              stream: postsReference.orderBy('createdAt').snapshots(),
              // ここで受け取っている snapshot に stream で流れてきたデータが入っています。
              builder: (context, snapshot) {
                // docs には Collection に保存されたすべてのドキュメントが入ります。
                // 取得までには時間がかかるのではじめは null が入っています。
                // null の場合は空配列が代入されるようにしています。
                final docs = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final post = docs[index].data();
                    return Text(post.text);
                  },
                );
              },
            ),
          ),

          TextFormField(
            onFieldSubmitted: (text) {
              //1,user変数にユーザーデータを格納。
              final user = FirebaseAuth.instance.currentUser!;
              final posterId = user.uid; //ログイン中のuserIdがとれる。
              final posterName = user.displayName!; // Googleアカウントの名前がとれます
              final posterImageUrl = user.photoURL!; // Googleアカウントのアイコンデータがとれます

              //２、ランダムなpostIdのドキュメントリファレンスを作成。
              final newDocumentReference = postsReference.doc();
              //因数を定義。mapclassの形。
              final newPost = Post(
                text: text,
                createdAt: Timestamp.now(), // 投稿日時は現在とします
                posterName: posterName,
                posterImageUrl: posterImageUrl,
                posterId: posterId,
                reference: newDocumentReference,
              );
              newDocumentReference.set(newPost);
            },
          ),
          // ),
        ],
=======
      body: Center(
        child: TextFormField(onFieldSubmitted: (text) {
          //クラスの使うオブジェクトを書く。
          final user = FirebaseAuth.instance.currentUser!;
          final posterId = user.uid; //ログイン中のuserIdがとれる。
          final posterName = user.displayName!; // Googleアカウントの名前がとれます
          final posterImageUrl = user.photoURL!; // Googleアカウントのアイコンデータがとれます

          // 先ほど作った postsReference からランダムなIDのドキュメントリファレンスを作成します
          // doc の引数を空にするとランダムなIDが採番されます
          final newDocumentReference = postsReference.doc();
          //因数を定義。mapclassの形。
          final newPost = Post(
            text: text,
            createdAt: Timestamp.now(), // 投稿日時は現在とします
            posterName: posterName,
            posterImageUrl: posterImageUrl,
            posterId: posterId,
            reference: newDocumentReference,
          );
          newDocumentReference.set(newPost);
        }),
>>>>>>> refs/remotes/origin/main
      ),
    );
  }
}
