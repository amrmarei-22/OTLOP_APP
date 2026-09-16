// features/auth/presentation/screens/sign_up_screen.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:otlop_app/core/common_widgets/custom_elevated_button.dart';
import 'package:otlop_app/core/common_widgets/custom_text_button.dart';
import 'package:otlop_app/core/common_widgets/titled_text_field.dart';
import 'package:otlop_app/core/helper/validators.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/features/auth/presentation/widgets/auth_divider_row.dart';
import 'package:otlop_app/features/auth/presentation/widgets/auth_header_section.dart';
import 'package:otlop_app/features/auth/presentation/widgets/auth_other_register_section.dart';
import 'package:otlop_app/features/auth/presentation/widgets/forget_pass_section.dart';
import 'package:otlop_app/features/auth/presentation/widgets/phone_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> myKey = GlobalKey<FormState>();
  final TextEditingController nameCtl = TextEditingController();
  final TextEditingController emailCtl = TextEditingController();
  final TextEditingController passwordCtl = TextEditingController();
  final TextEditingController phoneCtl = TextEditingController();
  bool isVisiable = true;

  Future<void> signUp() async {
    final Dio dio = Dio();
    try {
      final Response response = await dio.post(
        "https://talabat639.runasp.net/api/Account/Register",
        data: {
          "displayName": nameCtl.text,
          "email": emailCtl.text,
          "password": passwordCtl.text,
          "phoneNumber": phoneCtl.text,
        },
      );

      log("response:$response");
    } on DioException catch (e) {
      log('error is : ${e.response!.data['errors']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 40, 25, 38),
          child: SingleChildScrollView(
            child: Form(
              key: myKey,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* Auth Header
                  AuthHeaderSection(
                    title: 'Create an account',
                    subTitle: 'Connect with your friends today!',
                  ),
                  SizedBox(height: 35),
                  //* TitledTextFiled
                  TitledTextField(
                    controller: nameCtl,
                    title: 'Name',
                    hintText: 'Enter your name',
                    validator: (name) {
                      return Validator.validateUserName(name!);
                    },
                  ),
                  TitledTextField(
                    controller: emailCtl,

                    title: 'Email Address',
                    hintText: 'Enter your email',
                    validator: (email) {
                      return Validator.validateEmail(email!);
                    },
                  ),
                  PhoneTextField(controller: phoneCtl),
                  TitledTextField(
                    controller: passwordCtl,

                    title: 'Password',
                    hintText: 'Enter your password',
                    obscureText: isVisiable,
                    suffixIcon: IconButton(
                      onPressed: () {
                        isVisiable = !isVisiable;
                        setState(() {});
                      },
                      icon: Icon(
                        isVisiable ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    validator: (pass) {
                      return Validator.validatePassword(pass!);
                    },
                  ),

                  //* ForgetPassSection
                  ForgetPassSection(),

                  CustomElevatedButton(
                    text: 'Sign Up',
                    onPressed: () async {
                      if (myKey.currentState!.validate()) {
                        log("Name: ${nameCtl.text}");
                        log("Email: ${emailCtl.text}");
                        log("Pass: ${passwordCtl.text}");
                        log("Pass: ${phoneCtl.text}");
                        await signUp();
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  AuthDividerRow(),
                  SizedBox(height: 15),

                  //* Auth Other Register
                  AuthOtherRegisterSection(),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account ?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomTextButton(
                        text: 'Login',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        textClr: AppColors.primayClr,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
