import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ModifyProfilePage extends StatefulWidget {
  const ModifyProfilePage({super.key});

  @override
  State<ModifyProfilePage> createState() => _ModifyProfilePageState();
}

class _ModifyProfilePageState extends State<ModifyProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String? email = FirebaseAuth.instance.currentUser?.email;

  String? newEmail;
  TextEditingController newEmailController = TextEditingController();
  //TODO パスワードは自動ログインの管理下にない。もう一度持ってくる。
  String? password;
  TextEditingController passController = TextEditingController();

  // ①update()の前に実行しログイン
  // Future<void> login() async {
  //   password = passController.text;
  //   await FirebaseAuth.instance
  //       .signInWithEmailAndPassword(email: email!, password: password!);
  // }

//ログイン
  Future<void> login(String id, String pass) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: id,
        password: pass,
      );
      //SignInがうまく行った場合の処理
      if (mounted) {
        _updateEmail();
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

  //ログイン後に実行。
  Future<void> _updateEmail() async {
    newEmail = newEmailController.text;
    await FirebaseAuth.instance.currentUser!.updateEmail(newEmail!);
  }

  @override
  Widget build(BuildContext context) {
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
              /// パスワード入力
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Password'),
                  icon: Icon(Icons.key),
                ),
                controller: passController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
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
                    login(email.toString(), passController.text);
                    // _updateEmail();
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
