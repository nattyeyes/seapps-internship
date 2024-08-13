import 'package:flutter/material.dart';
import 'package:internship_application/services/auth_services.dart';
import 'package:internship_application/utils/custom_textfield.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController suffixController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final AuthService authService = AuthService();

  void createEmployee() {
    authService.createEmployee(
      context: context,
      firstName: firstNameController.text,
      middleName: middleNameController.text,
      lastName: lastNameController.text,
      suffix: suffixController.text,
      email: emailController.text,
      password: passwordController.text,
      phoneNo: phoneNoController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Create Employee",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextfield(
              controller: firstNameController,
              hintText: "Enter your first name",
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextfield(
              controller: middleNameController,
              hintText: "Enter your middle name",
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextfield(
              controller: lastNameController,
              hintText: "Enter your last name",
            ),
          ),
        ],
      )
    );
  }
}