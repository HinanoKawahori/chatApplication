import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.text,
    required this.createdAt,
    required this.posterId,
    required this.reference,
  });

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!; // data() の中には Map 型のデータが入っています。
    // data()! この ! 記号は nullable な型を non-nullable として扱うよ！ という意味です。
    // data の中身はかならず入っているだろうという仮説のもと ! をつけています。
    // map データが得られているのでここからはいつもと同じです。
    return Post(
      text: map['text'],
      createdAt: map['createdAt'],
      posterId: map['posterId'],
      reference:
          snapshot.reference, // 注意。reference は map ではなく snapshot に入っています。
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'createdAt': createdAt,
      'posterId': posterId,
    };
  }

  /// 投稿文
  final String text;

  /// 投稿日時
  final Timestamp createdAt;

  /// 投稿者のユーザーID
  final String posterId;

  /// Firestoreのどこにデータが存在するかを表すpath情報
  final DocumentReference reference;
}
