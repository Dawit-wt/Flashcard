import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutterfiretest/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterfiretest/alert_dialog.dart';

class AddCard extends StatefulWidget {
  final void Function(int) setIndex;

  const AddCard(this.setIndex, {super.key});

  @override
  AddCardState createState() => AddCardState();
}

class AddCardState extends State<AddCard> {
  final TextEditingController deckNameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController frontController = TextEditingController();
  final TextEditingController backController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  bool _deckNameValidate = true;
  bool _descValidate = true;
  bool _frontValidate = true;
  bool _backValidate = true;
  bool _cardValidate = true;
  bool _tagValidate = true;
  bool _customTagValidate = true;
  String _errorMessage = '';

  String? tag;
  late String tagValue;
  final List<String> _tags = ["DBMS", "ADA", "CN", "OS", "New Tag"];
  bool customTag = false;
  final List<Map<String, String>> cards = [];

  void addCard() {
    setState(() {
      _frontValidate = frontController.text.isEmpty ? false : true;
      _backValidate = backController.text.isEmpty ? false : true;
      _errorMessage = '';
    });

    if (_backValidate && _frontValidate) {
      setState(() {
        cards.add({
          "front": frontController.text,
          "back": backController.text,
        });
        frontController.clear();
        backController.clear();
        _cardValidate = true;
      });
    }
  }

  void cancel() {
    deckNameController.clear();
    descController.clear();
    frontController.clear();
    backController.clear();
    tagController.clear();
    setState(() {
      tag = null;
      customTag = false;
      cards.clear();
      _deckNameValidate = true;
      _descValidate = true;
      _frontValidate = true;
      _backValidate = true;
      _cardValidate = true;
      _tagValidate = true;
      _customTagValidate = true;
      _errorMessage = '';
    });
  }

  void post() async {
    setState(() {
      _deckNameValidate = deckNameController.text.isEmpty ? false : true;
      _descValidate = descController.text.isEmpty ? false : true;
      _cardValidate = cards.isEmpty ? false : true;
      if (customTag) {
        _customTagValidate = tagController.text.isEmpty ? false : true;
        tagValue = tagController.text;
      } else {
        _tagValidate = tag != null;
        tagValue = tag ?? '';
      }
      _errorMessage = '';
    });

    if (_deckNameValidate &&
        _descValidate &&
        (_tagValidate || _customTagValidate) &&
        _cardValidate) {
      final action = await Dialogs.yesAbort(
        context,
        "Post Deck",
        "Are you sure?",
        "Post",
        "No",
      );

      if (action == DialogAction.yes) {
        try {
          final deckid = await DatabaseService().addDeck(
            deckNameController.text,
            descController.text,
            tagValue,
          );

          for (var card in cards) {
            await DatabaseService().addCard(
              deckid,
              card["front"]!,
              card["back"]!,
            );
          }

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Deck created successfully")),
          );
          widget.setIndex(0);
        } catch (e) {
          if (!mounted) return;
          setState(() {
            _errorMessage = 'Error creating deck: $e';
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
            "Create a Deck",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: Text(
                              "Specify Deck details:",
                              style: TextStyle(
                                color: theme.primary,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 300.0,
                              height: 50.0,
                              child: TextFormField(
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      _deckNameValidate = true;
                                      _errorMessage = '';
                                    });
                                  }
                                },
                                controller: deckNameController,
                                style: TextStyle(
                                  color: theme.primaryContainer,
                                ),
                                cursorColor: theme.primaryContainer,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _deckNameValidate
                                          ? theme.primaryContainer
                                          : theme.onError,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40.0)),
                                    borderSide: BorderSide(
                                      color: _deckNameValidate
                                          ? theme.primaryContainer
                                          : theme.onError,
                                    ),
                                  ),
                                  labelText: "Deck name",
                                  labelStyle: TextStyle(
                                    color: _deckNameValidate
                                        ? theme.primaryContainer
                                        : theme.onError,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            SizedBox(
                              width: 300.0,
                              height: 50.0,
                              child: TextFormField(
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      _descValidate = true;
                                      _errorMessage = '';
                                    });
                                  }
                                },
                                controller: descController,
                                style: TextStyle(
                                  color: theme.primaryContainer,
                                ),
                                cursorColor: theme.primaryContainer,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _descValidate
                                          ? theme.primaryContainer
                                          : theme.onError,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40.0)),
                                    borderSide: BorderSide(
                                      color: _descValidate
                                          ? theme.primaryContainer
                                          : theme.onError,
                                    ),
                                  ),
                                  labelText: "Description",
                                  labelStyle: TextStyle(
                                    color: _descValidate
                                        ? theme.primaryContainer
                                        : theme.onError,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 300.0,
                              height: 50.0,
                              child: DropdownButtonFormField<String>(
                                items: _tags.map((String category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Row(
                                      children: [
                                        Text(
                                          category,
                                          style: TextStyle(
                                            color: theme.primaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    tag = newValue;
                                    _tagValidate = true;
                                    if (tag == "New Tag") {
                                      customTag = true;
                                    } else {
                                      customTag = false;
                                      _customTagValidate = true;
                                    }
                                    _errorMessage = '';
                                  });
                                },
                                value: tag,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _tagValidate
                                          ? theme.primaryContainer
                                          : theme.onError,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40.0)),
                                    borderSide: BorderSide(
                                      color: _tagValidate
                                          ? theme.primaryContainer
                                          : theme.onError,
                                    ),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 20, 10, 0),
                                  labelText: "Select Tag",
                                  labelStyle: TextStyle(
                                    color: _tagValidate
                                        ? theme.primaryContainer
                                        : theme.onError,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: customTag ? 20.0 : 0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 300.0,
                              height: customTag ? 50.0 : 0.0,
                              child: customTag
                                  ? TextFormField(
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          setState(() {
                                            _customTagValidate = true;
                                            _errorMessage = '';
                                          });
                                        }
                                      },
                                      controller: tagController,
                                      style: TextStyle(
                                        color: theme.primaryContainer,
                                      ),
                                      cursorColor: theme.primaryContainer,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: _customTagValidate
                                                ? theme.primaryContainer
                                                : theme.onError,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40.0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40.0)),
                                          borderSide: BorderSide(
                                            color: _customTagValidate
                                                ? theme.primaryContainer
                                                : theme.onError,
                                          ),
                                        ),
                                        labelText: "Custom tag",
                                        labelStyle: TextStyle(
                                          color: _customTagValidate
                                              ? theme.primaryContainer
                                              : theme.onError,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.primaryContainer,
                              width: 1,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 270.0,
                                      height: 50.0,
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
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(40.0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(40.0)),
                                            borderSide: BorderSide(
                                              color: _frontValidate
                                                  ? theme.primaryContainer
                                                  : theme.onError,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
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
                                const SizedBox(height: 20.0),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 270.0,
                                      height: 50.0,
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
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(40.0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(40.0)),
                                            borderSide: BorderSide(
                                              color: _backValidate
                                                  ? theme.primaryContainer
                                                  : theme.onError,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      icon: Icon(
                                        EvaIcons.plusCircleOutline,
                                        color: theme.primary,
                                      ),
                                      onPressed: addCard,
                                      label: Text(
                                        "Add Card",
                                        style: TextStyle(
                                          color: theme.primary,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: theme.primary
                                            .withValues(alpha: 0.3),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: _cardValidate && _errorMessage.isEmpty
                                  ? null
                                  : Text(
                                      _cardValidate
                                          ? _errorMessage
                                          : "A deck must contain at least 1 card!",
                                      style: TextStyle(
                                        color: theme.onError,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(
                                EvaIcons.close,
                                color: Color(0xff950F0F),
                              ),
                              onPressed: cancel,
                              label: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Color(0xff950F0F),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xffEDA9A9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            TextButton.icon(
                              icon: const Icon(
                                EvaIcons.checkmarkCircle,
                                color: Color(0xff08913F),
                              ),
                              onPressed: post,
                              label: const Text(
                                "Create Deck",
                                style: TextStyle(color: Color(0xff08913F)),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xffA9EDC4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                cards.isEmpty
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            "This deck has no cards yet!",
                            style: TextStyle(
                              color: theme.primary,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                '${cards.length} card(s) added to the deck:',
                                style: TextStyle(
                                  color: theme.primary,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: ListView.builder(
                              itemCount: cards.length,
                              itemBuilder: (_, index) {
                                return Slidable(
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          setState(() {
                                            cards.removeAt(index);
                                            if (cards.isEmpty) {
                                              _cardValidate = false;
                                            }
                                          });
                                        },
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.red[600],
                                        icon: EvaIcons.trashOutline,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: theme.surface,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          cards[index]["front"]!,
                                          style: TextStyle(
                                            color: theme.primary,
                                          ),
                                        ),
                                        subtitle: Text(
                                          cards[index]["back"]!,
                                          style: TextStyle(
                                            color: theme.secondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
