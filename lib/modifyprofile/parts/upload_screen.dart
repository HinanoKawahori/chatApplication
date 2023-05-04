//File
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadScreen extends StatefulWidget {
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
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
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      //uidでランダムパスを作り、storageに保存。
      final auth.User? user = auth.FirebaseAuth.instance.currentUser;
      final String randomPass =
          user!.uid + '_' + DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'UL/$randomPass.png';
      //storageに、fileNameで場所特定し、fileを保存する。
      final snapshot = await storage.ref(fileName).putFile(file);
      //ダウンロードURLを取得する
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      ////後半（cloudstoreにファイルのURLを保存)////
      // Firestoreに画像のダウンロードURLを保存する
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('users');
      final DocumentReference doc = collection.doc(user!.uid);
      // await doc.set({'imageUrl': downloadUrl}, SetOptions(merge: true));
      await doc.update({
        'imageUrl': downloadUrl,
      });

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
