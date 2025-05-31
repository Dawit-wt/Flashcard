import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../alert_dialog.dart';
import '../auth_service.dart';

class EditUser extends StatefulWidget {
  final Function setIndex;
  const EditUser(this.setIndex, {Key? key}) : super(key: key);

  @override
  EditUserState createState() => EditUserState(setIndex);
}

class EditUserState extends State<EditUser> {
  final Function setIndex;

  EditUserState(this.setIndex);

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool wrongPassword = false;
  bool _newPasswordValidate = true;
  bool _oldPasswordValidate = true;
  String _errorMessage = '';

  Future<bool> checkPassword() async {
    return await context
        .read<AuthService>()
        .checkPassword(oldPasswordController.text);
  }

  void editPassword() async {
    setState(() {
      _oldPasswordValidate = (oldPasswordController.text.isEmpty ||
              oldPasswordController.text.length < 6)
          ? false
          : true;
      _newPasswordValidate = (newPasswordController.text.isEmpty ||
              newPasswordController.text.length < 6)
          ? false
          : true;
      wrongPassword = false;
      _errorMessage = '';
    });

    if (_newPasswordValidate && _oldPasswordValidate) {
      final action = await Dialogs.yesAbort(
          context, "Edit Password", "Are you sure?", "Edit", "No");
      if (action == DialogAction.yes) {
        try {
          final isPasswordCorrect = await checkPassword();
          if (isPasswordCorrect) {
            final result = await context
                .read<AuthService>()
                .editPassword(newPasswordController.text);
            if (!mounted) return;
            if (result == "Password updated successfully") {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result)),
              );
              setIndex(2);
            } else {
              setState(() {
                _errorMessage = result;
              });
            }
          } else {
            setState(() {
              wrongPassword = true;
              _oldPasswordValidate = false;
            });
          }
        } catch (e) {
          if (!mounted) return;
          setState(() {
            _errorMessage = 'Error: $e';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text(
            "Edit Password",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Center(
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 300,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _oldPasswordValidate = true;
                          wrongPassword = false;
                          _errorMessage = '';
                        });
                      }
                    },
                    controller: oldPasswordController,
                    obscureText: true,
                    style: TextStyle(
                      color: _oldPasswordValidate
                          ? theme.primaryContainer
                          : theme.onError,
                    ),
                    cursorColor: theme.primaryContainer,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _oldPasswordValidate
                              ? theme.primaryContainer
                              : theme.onError,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40.0)),
                        borderSide: BorderSide(
                          color: _oldPasswordValidate
                              ? theme.primaryContainer
                              : theme.onError,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10.0),
                      labelText: "Enter old password",
                      labelStyle: TextStyle(
                        color: _oldPasswordValidate
                            ? theme.primaryContainer
                            : theme.onError,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: wrongPassword || _errorMessage.isNotEmpty ? 24 : 0,
                  child: wrongPassword
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Wrong Password",
                            style: TextStyle(
                              color: theme.onError,
                            ),
                          ),
                        )
                      : _errorMessage.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                _errorMessage,
                                style: TextStyle(
                                  color: theme.onError,
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
                          _newPasswordValidate = true;
                          _errorMessage = '';
                        });
                      }
                    },
                    controller: newPasswordController,
                    style: TextStyle(
                      color: _newPasswordValidate
                          ? theme.primaryContainer
                          : theme.onError,
                    ),
                    cursorColor: theme.primaryContainer,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _newPasswordValidate
                              ? theme.primaryContainer
                              : theme.onError,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40.0)),
                        borderSide: BorderSide(
                          color: _newPasswordValidate
                              ? theme.primaryContainer
                              : theme.onError,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10.0),
                      labelText: "Enter new password",
                      labelStyle: TextStyle(
                        color: _newPasswordValidate
                            ? theme.primaryContainer
                            : theme.onError,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  icon: Icon(
                    EvaIcons.checkmark,
                    color: theme.primaryContainer,
                  ),
                  label: Text(
                    "Edit Password",
                    style: TextStyle(
                      color: theme.primaryContainer,
                    ),
                  ),
                  onPressed: editPassword,
                  style: TextButton.styleFrom(
                    backgroundColor:
                        theme.primaryContainer.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
