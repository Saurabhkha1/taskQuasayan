import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_innoventure/core/utils/password_validator.dart';
import 'package:test_innoventure/core/widget/custom_button.dart';
import 'package:test_innoventure/core/widget/custom_textfield.dart';
import 'package:test_innoventure/feature/home/presentation/pages/home_page.dart';
import 'package:test_innoventure/feature/login/domain/usecase/validate_email.dart';
import 'package:test_innoventure/feature/login/presentation/bloc/login_cubit.dart';
import 'package:test_innoventure/feature/login/presentation/bloc/login_state.dart';
import 'package:test_innoventure/feature/login/presentation/bloc/password_visibility_cubit.dart';
import 'package:test_innoventure/feature/signup/presentation/pages/signup_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<String?> _emailErrorNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _passwordErrorNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<bool> _isButtonEnabledNotifier =
      ValueNotifier<bool>(false);
  final ValidateEmail _validateEmail = ValidateEmail();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              LoginCubit(firebaseAuth: FirebaseAuth.instance)..checkSession(),
        ),
        BlocProvider(
          create: (context) => PasswordVisibilityCubit(),
        ),
      ],
      child: Scaffold(
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginAuth) {
              _emailController.text = '';
              _passwordController.text = '';
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is LoginSuccess) {
              _emailController.text = '';
              _passwordController.text = '';
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }
          },
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              if (state is LoginLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Image.asset('assets/images/flutter_icon.png'),
                      ),
                      ValueListenableBuilder(
                          valueListenable: _emailErrorNotifier,
                          builder: (context, emailError, child) {
                            return SizedBox(
                              width: kIsWeb ? 420 : double.infinity,
                              child: CustomTextField(
                                textFieldController: _emailController,
                                hintText: 'User Email',
                                prefixIcon: const Icon(Icons.person,
                                    color: Colors.blue),
                                errorText: emailError,
                                onChanged: (value) {
                                  if (_emailController.text.isEmpty) {
                                    _emailErrorNotifier.value =
                                        'Please Enter Email Address';
                                  } else if (_validateEmail(value)) {
                                    _emailErrorNotifier.value = null;
                                  } else {
                                    _emailErrorNotifier.value =
                                        'Invalid Email Format';
                                  }
                                  _validateForm();
                                },
                              ),
                            );
                          }),
                      ValueListenableBuilder(
                          valueListenable: _passwordErrorNotifier,
                          builder: (context, passwordError, child) {
                            return BlocBuilder<PasswordVisibilityCubit, bool>(
                              builder: (context, isObscure) {
                                return SizedBox(
                                  width: kIsWeb ? 420 : double.infinity,
                                  child: CustomTextField(
                                    textFieldController: _passwordController,
                                    hintText: 'Password',
                                    obscureText: isObscure,
                                    errorText: passwordError,
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.blue,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          isObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.blue),
                                      onPressed: () {
                                        context
                                            .read<PasswordVisibilityCubit>()
                                            .toggleVisibility();
                                      },
                                    ),
                                    onChanged: (value) {
                                      if (_passwordController.text.isEmpty) {
                                        _passwordErrorNotifier.value =
                                            'Please Enter Password';
                                      } else if (PasswordValidator.isValid(
                                          value)) {
                                        _passwordErrorNotifier.value = null;
                                      } else {
                                        _passwordErrorNotifier.value =
                                            'Password must be at least 6 characters, include an uppercase letter, a number, and a special character';
                                      }
                                      _validateForm();
                                    },
                                  ),
                                );
                              },
                            );
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      ValueListenableBuilder(
                          valueListenable: _isButtonEnabledNotifier,
                          builder: (context, isButtonEnabled, child) {
                            return SizedBox(
                              width: kIsWeb ? 420 : double.infinity,
                              child: CustomButton(
                                onPressed: isButtonEnabled
                                    ? () {
                                        final email = _emailController.text;
                                        final password =
                                            _passwordController.text;
                                        context
                                            .read<LoginCubit>()
                                            .login(email, password);
                                      }
                                    : null,
                                buttonText: 'Login',
                              ),
                            );
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      GestureDetector(
                        child: const Text("Test app crash"),
                        onTap: () => FirebaseCrashlytics.instance.crash(),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      SizedBox(
                        width: kIsWeb ? 420 : double.infinity,
                        child: CustomButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                          },
                          buttonText: 'Don\'t have account? Sign Up',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _validateForm() {
    final isEmailValid = _validateEmail(_emailController.text);
    final isPasswordValid = PasswordValidator.isValid(_passwordController.text);
    _isButtonEnabledNotifier.value = isEmailValid && isPasswordValid;
  }
}
