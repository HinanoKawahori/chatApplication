import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'userData.freezed.dart';
part 'userData.g.dart';

@freezed
class userData with _$userData {
  factory userData({
    required String userId,
    required String imageUrl,
    required String userName,
  }) = _userData;

  factory userData.fromJson(Map<String, dynamic> json) =>
      _$userDataFromJson(json);
}
