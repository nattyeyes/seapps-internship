// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Employee {
  final String id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String suffix;
  final String email;
  final String password;
  final String phoneNo;

  Employee({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.suffix,
    required this.email,
    required this.password,
    required this.phoneNo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'suffix': suffix,
      'email': email,
      'password': password,
      'phoneNo': phoneNo,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      middleName: map['middleName'] as String,
      lastName: map['lastName'] as String,
      suffix: map['suffix'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phoneNo: map['phoneNo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) => Employee.fromMap(json.decode(source) as Map<String, dynamic>);
}
