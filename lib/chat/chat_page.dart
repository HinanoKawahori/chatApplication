import 'package:chatapplication/chat/components/post_builder.dart';
import 'package:chatapplication/chat/components/post_builder2.dart';
import 'package:chatapplication/modifyprofile/screen/modifyprofile_page.dart';
import 'package:chatapplication/data_models/post/post.dart';
import 'package:chatapplication/sign_in_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // child1, streambuilder
            Expanded(
              child: PostBuilder2(),
            ),
            // PostBuilder2(),

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
    final postId = Uuid().v1();
    // postクラスを生成。
    final newPost = Post(
      text: text,
      createdAt: DateTime.now(),
      //投稿者id(postnい)
      posterId: posterId,
      //postid
      postId: postId,
    );
    print(newPost);
    // firebaseに保存
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .set(newPost.toJson());
  }
}
