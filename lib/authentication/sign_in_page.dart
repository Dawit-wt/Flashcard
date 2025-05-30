import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterfiretest/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class SignInPage extends StatefulWidget {
  final Function() toggle;
  const SignInPage({super.key, required this.toggle});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool wrongEmail = false;
  bool wrongPassword = false;
  bool _emailValidate = true;
  bool _passwordValidate = true;
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
                      "Sign In",
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
                              wrongEmail = false;
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
                      height: wrongEmail ? 24 : 0,
                      child: wrongEmail
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Email does not exist",
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
                              wrongPassword = false;
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
                    SizedBox(
                      height: wrongPassword ? 24 : 0,
                      child: wrongPassword
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Wrong password",
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
                        "Sign In",
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
                          wrongEmail = false;
                          wrongPassword = false;
                          _errorMessage = '';
                        });

                        if (_emailValidate && _passwordValidate) {
                          final result =
                              await context.read<AuthService>().signIn(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                          setState(() {
                            if (result == "user-not-found") {
                              wrongEmail = true;
                              _emailValidate = false;
                            } else if (result == "wrong-password") {
                              wrongPassword = true;
                              _passwordValidate = false;
                            } else if (result != "Success") {
                              _errorMessage = 'Sign-in failed: $result';
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
                        child: const Text("Don't have an Account?"),
                        onPressed: () {
                          widget.toggle();
                        },
                      ),
                    ),
                    Container(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text("Forgot Password?"),
                        onPressed: () {
                          Navigator.pushNamed(context, "/forgotPassword");
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
