import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';

//TODO 確認
//設計図ポスト
@freezed
class Post with _$Post {
  const factory Post({
    required String text,
    required Timestamp createdAt,
    required String posterId,
    required DocumentReference reference,
  }) = _Post;

//インスタンスの生成
//firebaseからpost型
//因数としてfirestoreのマップ型documentsnapshotを受け取り、Postのインスタンスを作る。
  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    //map = data{key, value}
    // documensSnapshot からmapに変換
    final map = snapshot.data()!;
    return Post(
      //map型のデータが得られる。
      //ex)text : map['text']  textにmap['text']を代入！
      text: map['text'],
      createdAt: map['createdAt'],
      // posterName: map['posterName'],
      // posterImageUrl: map['posterImageUrl'],
      posterId: map['posterId'],
      reference: snapshot.reference,
    );
  }

//post型からfirebase
//PostインスタンスからMap<String, dynamic>に変換するためのtoMap関数。
  Map<String, dynamic> toMap() {
    return {
      //プロパティ名＝key名、 Firestore にデータを保存するときに活躍
      'text': text,
      'createdAt': createdAt,
      // 'posterName': posterName,
      // 'posterImageUrl': posterImageUrl,
      'posterId': posterId,
    };
  }
}
