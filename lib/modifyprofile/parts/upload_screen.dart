//File
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatefulWidget {
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  /// ユーザIDの取得
  Image? _img;
  Text? _text;
  // Get the Firebase Auth instance

  // アップロード処理
  Future<void> _upload() async {
    // imagePickerで画像を選択する
    final pickerFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerFile == null) {
      return;
    }
    //storageに保存の定義
    io.File file = io.File(pickerFile.path); //fileのパスを取得
    print(file);
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      //TODO　１、ファイルをFirebase Storageに保存する。
      final snapshot = //ref(保存場所)、putFile(ファイル実物)
          await storage.ref("UL/upload-pic.png").putFile(file);
      //2ダウンロードURLを取得する
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      // Firestoreに画像のダウンロードURLを保存する
      final auth.User? user = auth.FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('users');
      final DocumentReference doc = collection.doc(user.uid);
      await doc.set({'imageUrl': downloadUrl}, SetOptions(merge: true));

      await storage.ref("UL/upload-pic.png").putFile(file); //保存するフォルダ
      setState(() {
        _img = null;
        _text = const Text("UploadDone");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('画像アップロード'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // ダウンロードしたイメージとテキストを表示
            children: [
              if (_img != null) _img!,
              if (_text != null) _text!,
            ],

            // _text?,
          ),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          FloatingActionButton(
            onPressed: _upload,
            child: const Icon(Icons.upload_outlined),
          ),
        ]));
  }
}
