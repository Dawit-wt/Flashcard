import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutterfiretest/alert_dialog.dart';
import 'package:flutterfiretest/database.dart';
import 'package:provider/provider.dart';
import 'package:flutterfiretest/auth_service.dart';

import '../app_state.dart';

class Settings extends StatefulWidget {
  final Function setIndex;
  const Settings(this.setIndex, {Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState(setIndex);
}

class SettingsState extends State<Settings> {
  final Function setIndex;

  SettingsState(this.setIndex);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text(
            "Options",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              _buildListTile(
                icon: EvaIcons.editOutline,
                title: "Edit Password",
                onTap: () => setIndex(5),
                theme: theme,
              ),
              _buildListTile(
                icon: EvaIcons.refreshOutline,
                title: "Reset Stats",
                onTap: () async {
                  final action = await Dialogs.yesAbort(
                      context, "Reset Stats", "Are you sure?", "Reset", "No");
                  if (action == DialogAction.yes) {
                    try {
                      final result = await DatabaseService().resetStats();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result)),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                theme: theme,
              ),
              _buildListTile(
                icon: EvaIcons.sunOutline,
                title: Provider.of<AppState>(context).mode,
                onTap: () {
                  Provider.of<AppState>(context, listen: false).changeTheme();
                  setIndex(0);
                },
                theme: theme,
              ),
              _buildListTile(
                icon: EvaIcons.logOutOutline,
                title: "Logout",
                onTap: () async {
                  final action = await Dialogs.yesAbort(
                      context, "Logout", "Are you sure?", "Logout", "No");
                  if (action == DialogAction.yes) {
                    final result = await context.read<AuthService>().signOut();
                    if (!mounted) return;
                    if (result != "Success") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $result')),
                      );
                    }
                  }
                },
                theme: theme,
              ),
              _buildListTile(
                icon: EvaIcons.personDeleteOutline,
                title: "Delete Account",
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => const DeleteAlert(),
                ),
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ColorScheme theme,
  }) {
    return Container(
      height: 55.0,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.secondary),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: theme.secondary),
        title: Text(
          title,
          style: TextStyle(
            color: theme.secondary,
            fontSize: 20,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class DeleteAlert extends StatefulWidget {
  const DeleteAlert({Key? key}) : super(key: key);

  @override
  DeleteAlertState createState() => DeleteAlertState();
}

class DeleteAlertState extends State<DeleteAlert> {
  bool wrongPassword = false;
  bool _passwordValidate = true;
  String _errorMessage = '';

  final TextEditingController passwordController = TextEditingController();

  Future<bool> checkPassword() async {
    return await context
        .read<AuthService>()
        .checkPassword(passwordController.text);
  }

  void deleteAccount() async {
    setState(() {
      _passwordValidate = passwordController.text.length >= 6;
      wrongPassword = false;
      _errorMessage = '';
    });

    if (_passwordValidate) {
      try {
        final isPasswordCorrect = await checkPassword();
        if (isPasswordCorrect) {
          final result = await context
              .read<AuthService>()
              .deleteUser(passwordController.text);
          if (!mounted) return;
          if (result.contains('successfully')) {
            Navigator.of(context).pop();
          } else {
            setState(() {
              _errorMessage = result;
            });
          }
        } else {
          setState(() {
            wrongPassword = true;
            _passwordValidate = false;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text('Delete Account', style: TextStyle(color: theme.primary)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: theme.surface,
      content: SizedBox(
        height: wrongPassword || _errorMessage.isNotEmpty ? 100.0 : 75.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              controller: passwordController,
              obscureText: true,
              cursorColor: theme.primaryContainer,
              style: TextStyle(
                color:
                    _passwordValidate ? theme.primaryContainer : theme.onError,
              ),
              decoration: InputDecoration(
                labelText: "Confirm password",
                labelStyle: TextStyle(
                  color: _passwordValidate
                      ? theme.primaryContainer
                      : theme.onError,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _passwordValidate
                          ? theme.primaryContainer
                          : theme.onError),
                  borderRadius: BorderRadius.circular(40.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _passwordValidate
                          ? theme.primaryContainer
                          : theme.onError),
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _passwordValidate = true;
                    wrongPassword = false;
                    _errorMessage = '';
                  });
                }
              },
            ),
            if (wrongPassword)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Wrong Password",
                  style: TextStyle(color: theme.onError, fontSize: 12),
                ),
              ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: theme.onError, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(EvaIcons.close, color: Color(0xff950F0F)),
          label:
              const Text("Cancel", style: TextStyle(color: Color(0xff950F0F))),
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xffEDA9A9),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            passwordController.clear();
            setState(() {
              wrongPassword = false;
              _errorMessage = '';
            });
          },
        ),
        TextButton.icon(
          icon: const Icon(EvaIcons.checkmark, color: Color(0xff08913F)),
          label:
              const Text("Confirm", style: TextStyle(color: Color(0xff08913F))),
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xffA9EDC4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          onPressed: deleteAccount,
        ),
      ],
    );
  }
}
