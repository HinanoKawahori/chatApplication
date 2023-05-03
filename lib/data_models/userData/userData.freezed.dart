// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'userData.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

userData _$userDataFromJson(Map<String, dynamic> json) {
  return _userData.fromJson(json);
}

/// @nodoc
mixin _$userData {
  String get userId => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $userDataCopyWith<userData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $userDataCopyWith<$Res> {
  factory $userDataCopyWith(userData value, $Res Function(userData) then) =
      _$userDataCopyWithImpl<$Res, userData>;
  @useResult
  $Res call({String userId, String imageUrl, String userName});
}

/// @nodoc
class _$userDataCopyWithImpl<$Res, $Val extends userData>
    implements $userDataCopyWith<$Res> {
  _$userDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? imageUrl = null,
    Object? userName = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_userDataCopyWith<$Res> implements $userDataCopyWith<$Res> {
  factory _$$_userDataCopyWith(
          _$_userData value, $Res Function(_$_userData) then) =
      __$$_userDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String imageUrl, String userName});
}

/// @nodoc
class __$$_userDataCopyWithImpl<$Res>
    extends _$userDataCopyWithImpl<$Res, _$_userData>
    implements _$$_userDataCopyWith<$Res> {
  __$$_userDataCopyWithImpl(
      _$_userData _value, $Res Function(_$_userData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? imageUrl = null,
    Object? userName = null,
  }) {
    return _then(_$_userData(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_userData implements _userData {
  _$_userData(
      {required this.userId, required this.imageUrl, required this.userName});

  factory _$_userData.fromJson(Map<String, dynamic> json) =>
      _$$_userDataFromJson(json);

  @override
  final String userId;
  @override
  final String imageUrl;
  @override
  final String userName;

  @override
  String toString() {
    return 'userData(userId: $userId, imageUrl: $imageUrl, userName: $userName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_userData &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.userName, userName) ||
                other.userName == userName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, imageUrl, userName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_userDataCopyWith<_$_userData> get copyWith =>
      __$$_userDataCopyWithImpl<_$_userData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_userDataToJson(
      this,
    );
  }
}

abstract class _userData implements userData {
  factory _userData(
      {required final String userId,
      required final String imageUrl,
      required final String userName}) = _$_userData;

  factory _userData.fromJson(Map<String, dynamic> json) = _$_userData.fromJson;

  @override
  String get userId;
  @override
  String get imageUrl;
  @override
  String get userName;
  @override
  @JsonKey(ignore: true)
  _$$_userDataCopyWith<_$_userData> get copyWith =>
      throw _privateConstructorUsedError;
}
