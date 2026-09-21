// features/auth/presentation/screens/login_screen.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/core/common_widgets/custom_elevated_button.dart';
import 'package:otlop_app/core/common_widgets/custom_text_button.dart';
import 'package:otlop_app/core/common_widgets/titled_text_field.dart';
import 'package:otlop_app/core/helper/validators.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:otlop_app/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:otlop_app/features/auth/presentation/cubits/auth_cubit/auth_states.dart';
import 'package:otlop_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:otlop_app/features/auth/presentation/widgets/auth_divider_row.dart';
import 'package:otlop_app/features/auth/presentation/widgets/auth_header_section.dart';
import 'package:otlop_app/features/auth/presentation/widgets/auth_other_register_section.dart';
import 'package:otlop_app/features/auth/presentation/widgets/forget_pass_section.dart';
import 'package:otlop_app/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> myKey = GlobalKey<FormState>();
  final TextEditingController emailCtl = TextEditingController();
  final TextEditingController passwordCtl = TextEditingController();
  final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource();

  bool isVisiable = true;
  @override
  void dispose() {
    log("=========");
    super.dispose();
    emailCtl.dispose();
    passwordCtl.dispose();
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
                    controller: emailCtl,

                    title: 'Email Address',
                    hintText: 'Enter your email',
                    validator: (email) {
                      return Validator.validateEmail(email!);
                    },
                  ),

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
                  BlocConsumer<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return state is LoginLoadingState
                          ? Center(child: CircularProgressIndicator())
                          : CustomElevatedButton(
                              text: 'Login',
                              onPressed: () async {
                                if (myKey.currentState!.validate()) {
                                  await context.read<AuthCubit>().login(
                                    email: emailCtl.text,
                                    pass: passwordCtl.text,
                                  );
                                }
                              },
                            );
                    },
                    listener: (context, state) {
                      if (state is LoginSuccessState) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                      } else if (state is LoginFailureState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Invalid email or pass")),
                        );
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
                        'Don`t have an account ?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomTextButton(
                        text: 'Sign Up',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: context.read<AuthCubit>(),
                                child: const SignUpScreen(),
                              ),
                            ),
                          );
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
