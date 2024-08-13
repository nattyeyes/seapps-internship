import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internship_application/models/employee.dart';
import 'package:internship_application/models/user.dart';
import 'package:internship_application/providers/user_provider.dart';
import 'package:internship_application/screens/home_screen.dart';
import 'package:internship_application/screens/signup_screen.dart';
import 'package:internship_application/utils/constants.dart';
import 'package:internship_application/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // create Employee
  void createEmployee({
    required BuildContext context,
    required String firstName,
    required String middleName,
    required String lastName,
    required String suffix,
    required String email,
    required String password,
    required String phoneNo,
  }) async {
    try {
      Employee employee = Employee(
        id: '',
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        suffix: suffix,
        email: email,
        password: password,
        phoneNo: phoneNo,
      );

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/employee'),
        body: employee.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackbar(
            context,
            'Employee Created!'
          );
        }
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void timeIn({
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/timein'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: () {
          showSnackbar(
            context,
            'Timed in for today!',
          );
        });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void timeOut({
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/timeout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: () {
          showSnackbar(
            context,
            'Timed out for today!',
          );
        });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  // Sign Up User
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '', 
        name: name, 
        email: email, 
        token: '', 
        password: password,
      );

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: () {
          showSnackbar(
            context,
            'Account created! Login with the same credentials.',
          );
        });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          userProvider.setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        },
      );

    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; chatset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${Constants.uri}/'),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'x-auth-token': token},
        );

        userProvider.setUser(userRes.body);
      }

    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SignupScreen(),
      ),
      (route) => false
    );
  }
}