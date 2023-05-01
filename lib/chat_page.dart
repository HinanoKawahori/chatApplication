import 'package:chatapplication/modifyprofile_page.dart';
import 'package:chatapplication/post.dart';
import 'package:chatapplication/sign_in_page.dart';
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // ログアウト処理
              // 内部で保持しているログイン情報等が初期化される
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return SignInPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  // （2） 実際に表示するページ(ウィジェット)を指定する
                  builder: (context) => ModifyProfilePage()));
        },
      ),
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
              // final posterName = user.displayName!; // Googleアカウントの名前がとれます
              // final posterImageUrl = user.photoURL!; // Googleアカウントのアイコンデータがとれます

              //２、ランダムなpostIdのドキュメントリファレンスを作成。
              //(doc();)で作れる。
              final newDocumentReference = postsReference.doc();
              //postクラス型からできるnewPostインスタンス。
              final newPost = Post(
                text: text,
                createdAt: Timestamp.now(), // 投稿日時は現在とします
                // posterName: posterName,
                // posterImageUrl: posterImageUrl,
                posterId: posterId,
                reference: newDocumentReference,
              );
              newDocumentReference.set(newPost);
            },
          ),
          // ),
        ],
      ),
    );
  }
}
