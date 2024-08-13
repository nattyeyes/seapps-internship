// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoginActivity {
  final String id;
  final String userId;
  final DateTime timeIn;
  final DateTime timeOut;

  LoginActivity({
    required this.id,
    required this.userId,
    required this.timeIn,
    required this.timeOut,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'timeIn': timeIn.millisecondsSinceEpoch,
      'timeOut': timeOut.millisecondsSinceEpoch,
    };
  }

  factory LoginActivity.fromMap(Map<String, dynamic> map) {
    return LoginActivity(
      id: map['id'] as String,
      userId: map['userId'] as String,
      timeIn: DateTime.fromMillisecondsSinceEpoch(map['timeIn'] as int),
      timeOut: DateTime.fromMillisecondsSinceEpoch(map['timeOut'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginActivity.fromJson(String source) => LoginActivity.fromMap(json.decode(source) as Map<String, dynamic>);
}
