import 'package:task_manager_rv/domain/task_model.dart';

class UserModel {
  final String uid;
  final String fullname;
  final String email;

  UserModel({
    required this.uid,
    required this.fullname,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullname': fullname,
        'email': email,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
        fullname: json['fullname'],
        email: json['email'],
      );
}
