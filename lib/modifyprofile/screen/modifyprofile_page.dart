import 'package:chatapplication/modifyprofile/parts/upload_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ModifyProfilePage extends StatefulWidget {
  const ModifyProfilePage({super.key});

  @override
  State<ModifyProfilePage> createState() => _ModifyProfilePageState();
}

class _ModifyProfilePageState extends State<ModifyProfilePage> {
  //validation
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  //ログインに必要な変数
  String? email = FirebaseAuth.instance.currentUser?.email; //emailのとってき方
  String? newEmail;
  TextEditingController newEmailController = TextEditingController();
  String? password;
  TextEditingController passController = TextEditingController();

  //名前変更に必要な変数
  String? newName;
  TextEditingController newNameController = TextEditingController();

  @override
  void dispose() {
    newEmailController.dispose();
    passController.dispose();
    newNameController.dispose();
    super.dispose();
  }

//ログイン
  Future<void> login(String email, String pass) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      //SignInがうまく行った場合の処理
      if (mounted) {
        _updateEmail();

        newEmailController.clear();
        passController.clear();
      }
    } on FirebaseAuthException catch (e) {}
  }

  //ログイン後に実行。
  Future<void> _updateEmail() async {
    newEmail = newEmailController.text; //Stringにするの忘れない。
    await FirebaseAuth.instance.currentUser!.updateEmail(newEmail!);
  }

//TODO firebaseUpdate   名前変更
  Future<void> _updateName() async {
    final docId = FirebaseAuth.instance.currentUser?.uid;
    newName = newNameController.text;
    //まず、データがあるか確認する。
    final docRef = FirebaseFirestore.instance.collection('users').doc(docId);
    final docSnapshot = await docRef.get();
    await docRef.update({
      'userName': newName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プロフィール変更'),
      ),
      // body: Form(
      //   key: _formKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// パスワード入力
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Password'),
                      icon: Icon(Icons.key),
                    ),
                    controller: passController,
                    //validation
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
                    //validation
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            /// メルアド変更
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  //validation
                  if (_formKey.currentState!.validate()) {
                    /// ログイン  String型にするの忘れない。
                    login(email.toString(), passController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('新しいメルアドに変更しました。')),
                    );
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: const Text('メルアド変更'),
              ),
            ),

            //名前変更テキストフィールド
            Form(
              key: _formKey2,
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text('put your name'),
                  icon: Icon(Icons.person),
                ),
                controller: newNameController, //validation
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),

            /// 名前変更ボタン
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  validation:
                  if (_formKey2.currentState!.validate()) {
                    _updateName();
                    newNameController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('名前を変更しました。')),
                    );
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: const Text('名前変更'),
              ),
            ),

            //画像アップロード
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadScreen(),
                      ));
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: const Text('アイコン変更ページへ移動'),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
