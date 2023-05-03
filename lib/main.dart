import 'package:chatapplication/chat/chat_page.dart';
import 'package:chatapplication/data_models/post/post.dart';
import 'package:chatapplication/sign_in_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // runApp 前に何かを実行したいときはこれが必要です。
  await Firebase.initializeApp(
    // これが Firebase の初期化処理です。
    options: DefaultFirebaseOptions.android,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          if (snapshot.hasData) {
            // User が null でなない、つまりサインイン済みのホーム画面へ
            return ChatPage();
          }
          // User が null である、つまり未サインインのサインイン画面へ
          return SignInPage();
        },
      ),
    );
  }
}

//TODO freezed???
//withConverterでcollectionReferenceを作る。
// final postsReference =
//     FirebaseFirestore.instance.collection('posts').withConverter<Post>(
//   // <> ここに変換したい型名をいれます。今回は Post です。
//   fromFirestore: ((snapshot, _) {
//     // 第二引数は使わないのでその場合は _ で不使用であることを分かりやすくしています。
//     return Post.fromJson(snapshot.data()!); // 先ほど定期着した fromFirestore がここで活躍します。
//   }),
//   toFirestore: ((Post postData, _) {
//     return postData.toJson(); // 先ほど適宜した toMap がここで活躍します。
//   }),
// );
