import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'userData.freezed.dart';
part 'userData.g.dart';

@freezed
class UserData with _$UserData {
  factory UserData({
    required String userId,
    required String imageUrl,
    required String userName,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
