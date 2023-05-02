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
  //validation
  final _formKey = GlobalKey<FormState>();

  final postController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  //TODO　質問　なかっても動くけど、どうなる？？
  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

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
              // 元の画面に戻らないように、
              // pushandremoveuntil(次のページに遷移しつつ、特定の条件のページまで過去のページを取り除く)をつける。
              await FirebaseAuth.instance.signOut();

              await Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) {
                    return SignInPage();
                  },
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      //TODO floatingactionbutton
      floatingActionButton: FloatingActionButton.extended(
        label: Text('メルアド変更'),
        icon: Icon(Icons.navigate_next),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ModifyProfilePage()));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //child1, streambuilder
            Expanded(
              child: StreamBuilder<QuerySnapshot<Post>>(
                // stream プロパティに snapshots() >> リアルタイム監視
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

            Form(
              key: _formKey,
              child: TextFormField(
                //TODO controllerを置いておけば、テキストフィールド以外のwidgetから
                //どんな文字があるかわかるようになる。
                controller: postController,
                decoration: const InputDecoration(
                  label: Text('your post here'),
                  icon: Icon(Icons.post_add),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //if　okeyなら、投稿
                    _post(postController.text);
                    postController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('ポスト投稿'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //タスク投稿
  Future<void> _post(String text) async {
    // 1,user変数にユーザーデータを格納。
    final user = FirebaseAuth.instance.currentUser!;
    final posterId = user.uid; //ログイン中のuserIdがとれる。
    // ２,ランダムなpostIdのドキュメントリファレンスを作成。doc();で作れる
    final newDocumentReference = postsReference.doc();

    final newPost = Post(
      text: text,
      createdAt: Timestamp.now(), // 投稿日時は現在とします
      posterId: posterId,
      reference: newDocumentReference,
    );
    print(newPost);
    // 3,postクラス型からできるnewPostインスタンス。
    await newDocumentReference.set(newPost);
  }
}
