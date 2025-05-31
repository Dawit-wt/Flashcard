import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../database.dart';

class EditCard extends StatefulWidget {
  final String front;
  final String back;
  final String cardId;
  final String deckId;
  final Function updateCardList;

  const EditCard({
    required this.front,
    required this.back,
    required this.cardId,
    required this.deckId,
    required this.updateCardList,
    super.key,
  });

  @override
  EditCardState createState() =>
      EditCardState(front, back, cardId, updateCardList);
}

class EditCardState extends State<EditCard> {
  final TextEditingController frontController = TextEditingController();
  final TextEditingController backController = TextEditingController();

  bool _frontValidate = true;
  bool _backValidate = true;
  String _errorMessage = '';

  final String front;
  final String back;
  final String cardId;
  final Function updateCardList;

  EditCardState(this.front, this.back, this.cardId, this.updateCardList);

  @override
  void initState() {
    super.initState();
    frontController.text = front;
    backController.text = back;
  }

  void editCard() async {
    setState(() {
      _frontValidate = frontController.text.isEmpty ? false : true;
      _backValidate = backController.text.isEmpty ? false : true;
      _errorMessage = '';
    });

    if (_frontValidate && _backValidate) {
      try {
        final result = await DatabaseService().editCard(
          frontController.text,
          backController.text,
          cardId,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
        updateCardList();
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'Error updating card: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(
        'Edit Card',
        style: TextStyle(color: theme.primary),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: theme.surface,
      content: SizedBox(
        height: _errorMessage.isEmpty ? 170.0 : 190.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 230.0,
                  height: 60.0,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _frontValidate = true;
                          _errorMessage = '';
                        });
                      }
                    },
                    maxLines: 2,
                    controller: frontController,
                    style: TextStyle(
                      color: theme.primaryContainer,
                    ),
                    cursorColor: theme.primaryContainer,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _frontValidate
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
                          color: _frontValidate
                              ? theme.primaryContainer
                              : theme.onError,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      labelText: "Front",
                      labelStyle: TextStyle(
                        color: _frontValidate
                            ? theme.primaryContainer
                            : theme.onError,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 230.0,
                  height: 60.0,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _backValidate = true;
                          _errorMessage = '';
                        });
                      }
                    },
                    maxLines: 2,
                    controller: backController,
                    style: TextStyle(
                      color: theme.primaryContainer,
                    ),
                    cursorColor: theme.primaryContainer,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _backValidate
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
                          color: _backValidate
                              ? theme.primaryContainer
                              : theme.onError,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      labelText: "Back",
                      labelStyle: TextStyle(
                        color: _backValidate
                            ? theme.primaryContainer
                            : theme.onError,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: theme.onError,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(
            EvaIcons.close,
            color: Color(0xff950F0F),
          ),
          onPressed: () => Navigator.of(context).pop(),
          label: const Text(
            "No",
            style: TextStyle(
              color: Color(0xff950F0F),
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xffEDA9A9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          ),
        ),
        TextButton.icon(
          icon: const Icon(
            EvaIcons.checkmark,
            color: Color(0xff08913F),
          ),
          onPressed: editCard,
          label: const Text(
            "Edit",
            style: TextStyle(
              color: Color(0xff08913F),
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xffA9EDC4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          ),
        ),
      ],
    );
  }
}
