import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
//名前付きコンストラクタ
  Post({
    required this.text,
    required this.createdAt,
    required this.posterName,
    required this.posterImageUrl,
    required this.posterId,
    required this.reference,
  });
//プロパティ
  /// 投稿文
  final String text;

  /// 投稿日時
  final Timestamp createdAt;

  /// 投稿者の名前
  final String posterName;

  /// 投稿者のアイコン画像URL
  final String posterImageUrl;

  /// 投稿者のユーザーID
  final String posterId;

  /// Firestoreのどこにデータが存在するかを表すpath情報
  final DocumentReference reference;

  // factory PixabayImage.fromMap(Map<String, dynamic> map) {
  //   return PixabayImage(
  //     previewURL: map['previewURL'],
  //     likes: map['likes'],
  //     webformatURL: map['webformatURL'],
  //   );
  // }
}
