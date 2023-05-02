import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //validation
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('パスワードの再登録'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // メールアドレス入力用テキストフィールド
                //①：formのkeyプロパティにオブジェクトを持たせる。

                Form(
                  key: _formKey,
                  child: TextFormField(
                    //②：バリデーションの処理を持たせたTextFormField Widgetを用意する
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },

                    decoration:
                        const InputDecoration(labelText: 'メールアドレスを入力してください'),

                    controller: emailController,
                  ),
                ),

                // パスワードリセットボタン
                ElevatedButton(
                    child: const Text('パスワードリセットする'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        //if okayなら、実行！
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text);
                          print("パスワードリセット用のメールを送信しました");
                        } catch (e) {
                          print(e);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
