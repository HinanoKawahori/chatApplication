import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ModifyProfilePage extends StatefulWidget {
  const ModifyProfilePage({super.key});

  @override
  State<ModifyProfilePage> createState() => _ModifyProfilePageState();
}

class _ModifyProfilePageState extends State<ModifyProfilePage> {
  String? email;
  String? password;
  final idController = TextEditingController();
  final passController = TextEditingController();

  //validation
  final _formKey = GlobalKey<FormState>();

  String? newEmail;
  TextEditingController newEmailController = TextEditingController();

  // ①update()の前に実行しログイン
  //ログイン
  Future<void> _signIn(String id, String pass) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: id,
        password: pass,
      );
      //SignInがうまく行った場合の処理
      if (mounted) {
        SnackBar(content: Text('valid user'));
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

  //updateEmail
  Future<void> _updateEmail() async {
    newEmail = newEmailController.text;
    await FirebaseAuth.instance.currentUser!.updateEmail(newEmail!);
  }

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    final passController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('メルアド変更'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //
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

              TextFormField(
                decoration: const InputDecoration(
                  label: Text('put your new email'),
                  icon: Icon(Icons.mail),
                ),

                controller: newEmailController,

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
                    _updateEmail();
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey)),
                  child: const Text('変更'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
