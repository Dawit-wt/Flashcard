import 'package:flutter/material.dart';
import 'package:flutterfiretest/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class SignUpPage extends StatefulWidget {
  final Function() toggle;
  const SignUpPage({super.key, required this.toggle});

  @override
  SignUpPageState createState() => SignUpPageState();
}

/// This widget is the root of your application.

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool emailExists = false;
  bool passwordMismatch = false;
  bool _emailValidate = true;
  bool _passwordValidate = true;
  bool _confirmPasswordValidate = true;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: Center(
          child: Form(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _emailValidate = true;
                              emailExists = false;
                              _errorMessage = '';
                            });
                          }
                        },
                        controller: emailController,
                        style: TextStyle(
                          color: _emailValidate
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.onError,
                        ),
                        cursorColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _emailValidate
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.onError,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(
                              color: _emailValidate
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.onError,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          labelText: "Enter email",
                          labelStyle: TextStyle(
                            color: _emailValidate
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.onError,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: emailExists ? 24 : 0,
                      child: emailExists
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Email already exists",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _passwordValidate = true;
                              passwordMismatch = false;
                              _errorMessage = '';
                            });
                          }
                        },
                        controller: passwordController,
                        style: TextStyle(
                          color: _passwordValidate
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.onError,
                        ),
                        cursorColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        obscureText: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _passwordValidate
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.onError,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(
                              color: _passwordValidate
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.onError,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          labelText: "Enter password",
                          labelStyle: TextStyle(
                            color: _passwordValidate
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.onError,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _confirmPasswordValidate = true;
                              passwordMismatch = false;
                              _errorMessage = '';
                            });
                          }
                        },
                        controller: confirmPasswordController,
                        style: TextStyle(
                          color: _confirmPasswordValidate
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.onError,
                        ),
                        cursorColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        obscureText: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _confirmPasswordValidate
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.onError,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(
                              color: _confirmPasswordValidate
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.onError,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          labelText: "Confirm password",
                          labelStyle: TextStyle(
                            color: _confirmPasswordValidate
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.onError,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: passwordMismatch ? 24 : 0,
                      child: passwordMismatch
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Passwords do not match",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 10),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ),
                      ),
                    TextButton.icon(
                      icon: Icon(
                        EvaIcons.checkmarkCircle,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      label: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _emailValidate = (emailController.text.isEmpty ||
                                  !EmailValidator.validate(
                                      emailController.text))
                              ? false
                              : true;
                          _passwordValidate =
                              (passwordController.text.isEmpty ||
                                      passwordController.text.length < 6)
                                  ? false
                                  : true;
                          _confirmPasswordValidate =
                              (confirmPasswordController.text.isEmpty ||
                                      confirmPasswordController.text.length < 6)
                                  ? false
                                  : true;
                          emailExists = false;
                          passwordMismatch = false;
                          _errorMessage = '';
                        });

                        if (_emailValidate &&
                            _passwordValidate &&
                            _confirmPasswordValidate) {
                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            setState(() {
                              passwordMismatch = true;
                              _confirmPasswordValidate = false;
                            });
                            return;
                          }

                          final result =
                              await context.read<AuthService>().signUp(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                          setState(() {
                            if (result == "email exists") {
                              emailExists = true;
                              _emailValidate = false;
                            } else if (result != "Success") {
                              _errorMessage = 'Sign-up failed: $result';
                            }
                            // Success case: Navigation handled by AuthenticationWrapper
                          });
                        }
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text("Already have an Account?"),
                        onPressed: () {
                          widget.toggle();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
