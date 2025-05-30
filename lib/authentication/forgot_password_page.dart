import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfiretest/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  String message = '';
  bool wrongEmail = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: const Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reset Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.blue, // Placeholder color, replace with Theme
                  ),
                ),
                SizedBox(height: 20),
                ForgotPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  ForgotPasswordFormState createState() => ForgotPasswordFormState();
}

class ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController emailController = TextEditingController();
  String message = '';
  bool wrongEmail = false;
  String _errorMessage = '';

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: 300,
          child: TextFormField(
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  wrongEmail = false;
                  message = '';
                  _errorMessage = '';
                });
              }
            },
            controller: emailController,
            style: TextStyle(
              color: wrongEmail
                  ? Theme.of(context).colorScheme.onError
                  : Theme.of(context).colorScheme.primaryContainer,
            ),
            cursorColor: Theme.of(context).colorScheme.primaryContainer,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: wrongEmail
                      ? Theme.of(context).colorScheme.onError
                      : Theme.of(context).colorScheme.primaryContainer,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(40.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                borderSide: BorderSide(
                  color: wrongEmail
                      ? Theme.of(context).colorScheme.onError
                      : Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              labelText: "Enter email",
              labelStyle: TextStyle(
                color: wrongEmail
                    ? Theme.of(context).colorScheme.onError
                    : Theme.of(context).colorScheme.primaryContainer,
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
        SizedBox(height: 10),
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
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
          ),
          child: Text(
            "Send Recovery Mail",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          onPressed: () async {
            final email = emailController.text.trim();
            setState(() {
              wrongEmail = false;
              _errorMessage = '';
            });

            if (!_isValidEmail(email)) {
              setState(() {
                wrongEmail = true;
              });
              return;
            }

            try {
              String result = await AuthService().forgotPassword(email);

              if (result == "Successful") {
                setState(() {
                  message = "Email sent successfully";
                });
              } else if (result == "user-not-found") {
                setState(() {
                  wrongEmail = true;
                });
              } else {
                setState(() {
                  _errorMessage = result;
                });
              }
            } catch (e) {
              setState(() {
                _errorMessage =
                    'Failed to send recovery email: ${e.toString()}';
              });
            }
          },
        ),
        SizedBox(height: 10),
        Text(
          message,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(30.0),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text("Go Back"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
