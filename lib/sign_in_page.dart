import 'package:chatapplication/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
//validation
  final _formKey = GlobalKey<FormState>();

//会員登録
  Future<void> _createAccount(String id, String pass) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: id,
        password: pass,
      );
      //うまくいかなかった場合
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('パスワードが弱いです');
      } else if (e.code == 'email-already-in-use') {
        print('すでに使用されているメールアドレスです');
      } else {
        print('アカウント作成エラー');
      }
    } catch (e) {
      print(e);
    }
  }

//ログイン
  Future<void> _signIn(String id, String pass) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: id,
        password: pass,
      );
      //SignInがうまく行った場合の処理
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
            return const ChatPage();
          }),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        print('メールアドレスが無効です');
      } else if (e.code == 'user-not-found') {
        print('ユーザーが存在しません');
      } else if (e.code == 'wrong-password') {
        print('パスワードが間違っています');
      } else {
        print('サインインエラー');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    final passController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GoogleSignIn'),
      ),
      body: Center(
        //①：formのkeyプロパティにオブジェクトを持たせる。ここ以下のWidgetを管理できるようになる

        child: Form(
          key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text('E-mail'),
                icon: Icon(Icons.mail),
              ),

              controller: idController,
              //obscureText: true,
              //②：バリデーションの処理を持たせたTextFormField Widgetを用意する
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            /// パスワード入力
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Password'),
                icon: Icon(Icons.key),
              ),
              controller: passController,
              //obscureText: true,
              //TODO 質問validatorの位置は関係ある？ ボタンを押した時に初めてvalueを認知する？
              //②：バリデーションの処理を持たせたTextFormField Widgetを用意する

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            /// サインイン
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  /// ログインの場合
                  ///3 idController.text, passController.textが入る。stringだから
                  _signIn(idController.text, passController.text);
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: const Text('サインイン'),
              ),
            ),

            /// アカウント作成
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  /// アカウント作成の場合
                  ///3 createAccount
                  _createAccount(idController.text, passController.text);
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('アカウント作成'),
              ),
            ),

            // }
          ]),
        ),
      ),
    );
  }
}
