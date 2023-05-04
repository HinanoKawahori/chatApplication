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
    ////前半（画像ファイルの生成)////
    final pickerFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerFile == null) {
      return;
    }
    io.File file = io.File(pickerFile.path);
    ////前半（storageに画像ファイルを保存)////
    //2、storageパスにファイルをアップロードする。
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      // //1,2 storageでのファイルの保存場所を指定し、ファイルをアップロード。
      //uidでランダムパスを作り、storageに保存。
      final auth.User? user = auth.FirebaseAuth.instance.currentUser;
      final String randomPass =
          user!.uid + '_' + DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'UL/$randomPass.png';
      // Upload the file to Firebase Storage
      final snapshot = await storage.ref(fileName).putFile(file);

      //3ダウンロードURLを取得する
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      ////後半（cloudstoreにファイルのURLを保存)////
      // Firestoreに画像のダウンロードURLを保存する
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('users');
      final DocumentReference doc = collection.doc(user!.uid);
      await doc.set({'imageUrl': downloadUrl}, SetOptions(merge: true));
      setState(() {
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
