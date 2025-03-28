import 'package:json_annotation/json_annotation.dart';
//执行代码生成
// flutter pub run build_runner build --delete-conflicting-outputs
part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  final String id;
  final String email;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String? avatar;
  final String? phone;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatar,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}