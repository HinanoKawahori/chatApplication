// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Post _$$_PostFromJson(Map<String, dynamic> json) => _$_Post(
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      posterId: json['posterId'] as String,
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$$_PostToJson(_$_Post instance) => <String, dynamic>{
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'posterId': instance.posterId,
      'postId': instance.postId,
    };
