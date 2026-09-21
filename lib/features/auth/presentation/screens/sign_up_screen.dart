// features/auth/presentation/screens/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:otlop_app/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:otlop_app/features/auth/presentation/cubits/auth_cubit/auth_states.dart';
import 'package:otlop_app/main_screen.dart';

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

  @override
  void dispose() {
    nameCtl.dispose();
    emailCtl.dispose();
    passwordCtl.dispose();
    phoneCtl.dispose();
    super.dispose();
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

                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is SignUpSuccessState) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => MainScreen()),
                        );
                      } else if (state is SignUpFailureState) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    },
                    builder: (context, state) {
                      if (state is SignUpLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primayClr,
                          ),
                        );
                      }
                      return CustomElevatedButton(
                        text: 'Sign Up',
                        onPressed: () {
                          if (myKey.currentState!.validate()) {
                            context.read<AuthCubit>().register(
                              name: nameCtl.text.trim(),
                              email: emailCtl.text.trim(),
                              password: passwordCtl.text,
                              phone: phoneCtl.text.trim(),
                            );
                          }
                        },
                      );
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
