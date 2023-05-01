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
  //ログインに必要な変数
  String? email = FirebaseAuth.instance.currentUser?.email; //emailのとってき方
  String? newEmail;
  TextEditingController newEmailController = TextEditingController();
  String? password;
  TextEditingController passController = TextEditingController();

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
      }
    } on FirebaseAuthException catch (e) {}
  }

  //ログイン後に実行。
  Future<void> _updateEmail() async {
    newEmail = newEmailController.text; //Stringにするの忘れない。
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

              /// サインイン
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    /// ログイン  String型にするの忘れない。
                    login(email.toString(), passController.text);
                    //validation
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
