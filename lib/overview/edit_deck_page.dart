import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterfiretest/overview/edit_card.dart';

import '../alert_dialog.dart';
import '../database.dart';
import 'deck_list.dart';

class EditDeck extends StatefulWidget {
  final Function setIndex;
  const EditDeck(this.setIndex, {Key? key}) : super(key: key);

  @override
  EditDeckState createState() => EditDeckState(setIndex);
}

class EditDeckState extends State<EditDeck> {
  final TextEditingController deckNameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final TextEditingController newFrontController = TextEditingController();
  final TextEditingController newBackController = TextEditingController();

  bool _deckNameValidate = true;
  bool _descValidate = true;
  bool _tagValidate = true;
  bool _customTagValidate = true;
  bool _newFrontValidate = true;
  bool _newBackValidate = true;
  bool _cardValidate = true;
  String _errorMessage = '';

  String? tag;
  late String tagValue;
  late String deckid;
  late String cardId;

  final List<String> _tags = ["DBMS", "ADA", "CN", "OS", "New Tag"];

  bool customTag = false;

  List<Map<String, dynamic>> cards = [];
  List<Map<String, dynamic>> newCards = [];

  final Function setIndex;
  Map<String, dynamic> deckDetails = {};

  EditDeckState(this.setIndex);

  Future<void> getData(String deckid) async {
    try {
      final deckDetailsResponse =
          await DatabaseService().getDeckDetails(deckid);
      final cardsResponse = await DatabaseService().getCardDetails(deckid);

      setState(() {
        deckDetails = deckDetailsResponse;
        cards = cardsResponse;
        deckNameController.text = deckDetails['deckname'];
        descController.text = deckDetails['desc'];
        tag = deckDetails['tag'];
        if (!_tags.contains(tag)) {
          _tags.add(tag!); // Add the existing tag if not in the list
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error fetching deck details: $e';
      });
    }
  }

  void editDeck() async {
    setState(() {
      _deckNameValidate = deckNameController.text.isEmpty ? false : true;
      _descValidate = descController.text.isEmpty ? false : true;
      if (customTag) {
        _customTagValidate = tagController.text.isEmpty ? false : true;
      } else {
        _tagValidate = tag != null;
      }
      _errorMessage = '';
    });

    if (customTag) {
      tagValue = tagController.text;
    } else {
      tagValue = tag ?? '';
    }

    if (_deckNameValidate &&
        _descValidate &&
        (_tagValidate && _customTagValidate)) {
      final action = await Dialogs.yesAbort(
        context,
        "Edit Deck",
        "Are you sure?",
        "Edit",
        "No",
      );

      if (action == DialogAction.yes) {
        try {
          final result = await DatabaseService().editDeck(
            deckNameController.text,
            descController.text,
            tagValue,
            deckid,
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
          setIndex(0);
        } catch (e) {
          if (!mounted) return;
          setState(() {
            _errorMessage = 'Error updating deck: $e';
          });
        }
      }
    }
  }

  Future<void> updateCardList() async {
    try {
      final temp = await DatabaseService().getCardDetails(deckid);
      if (!mounted) return;
      setState(() {
        cards = temp;
        _cardValidate = cards.isNotEmpty;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error updating card list: $e';
      });
    }
  }

  void addNewCard() async {
    setState(() {
      _newFrontValidate = newFrontController.text.isEmpty ? false : true;
      _newBackValidate = newBackController.text.isEmpty ? false : true;
      _errorMessage = '';
    });

    if (_newBackValidate && _newFrontValidate) {
      try {
        await DatabaseService().addCard(
          deckid,
          newFrontController.text,
          newBackController.text,
        );
        await updateCardList();
        setState(() {
          newFrontController.clear();
          newBackController.clear();
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'Error adding card: $e';
        });
      }
    }
  }

  void deleteCard() async {
    try {
      await DatabaseService().deleteOneCard(cardId);
      await updateCardList();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error deleting card: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    deckid = DeckListState.deckid ?? '';
    getData(deckid);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text(
            "Edit Deck",
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
                //
                // Deck and card form
                //
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
                              "Edit Deck details:",
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
                                      Radius.circular(40.0),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(40.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: _deckNameValidate
                                          ? theme.primaryContainer
                                          : theme.onError,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.0,
                                    horizontal: 10.0,
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
                                      Radius.circular(40.0),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(40.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: _descValidate
                                          ? theme.primaryContainer
                                          : theme.onError,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.0,
                                    horizontal: 10.0,
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
                                      Radius.circular(40.0),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(40.0),
                                    ),
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
                                            Radius.circular(40.0),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(40.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: _customTagValidate
                                                ? theme.primaryContainer
                                                : theme.onError,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 0.0,
                                          horizontal: 10.0,
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
                        //
                        // Card form
                        //
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
                                              _newFrontValidate = true;
                                              _errorMessage = '';
                                            });
                                          }
                                        },
                                        maxLines: 2,
                                        controller: newFrontController,
                                        style: TextStyle(
                                          color: theme.primaryContainer,
                                        ),
                                        cursorColor: theme.primaryContainer,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _newFrontValidate
                                                  ? theme.primaryContainer
                                                  : theme.onError,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(40.0),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(40.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: _newFrontValidate
                                                  ? theme.primaryContainer
                                                  : theme.onError,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 20.0,
                                          ),
                                          labelText: "Front",
                                          labelStyle: TextStyle(
                                            color: _newFrontValidate
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
                                              _newBackValidate = true;
                                              _errorMessage = '';
                                            });
                                          }
                                        },
                                        maxLines: 2,
                                        controller: newBackController,
                                        style: TextStyle(
                                          color: theme.primaryContainer,
                                        ),
                                        cursorColor: theme.primaryContainer,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _newBackValidate
                                                  ? theme.primaryContainer
                                                  : theme.onError,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(40.0),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(40.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: _newBackValidate
                                                  ? theme.primaryContainer
                                                  : theme.onError,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 20.0,
                                          ),
                                          labelText: "Back",
                                          labelStyle: TextStyle(
                                            color: _newBackValidate
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
                                        color: theme.primaryContainer,
                                      ),
                                      onPressed: addNewCard,
                                      label: Text(
                                        "Add New Card",
                                        style: TextStyle(
                                          color: theme.primaryContainer,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: theme.primaryContainer
                                            .withValues(alpha: 0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
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
                            SizedBox(
                              height: _cardValidate && _errorMessage.isEmpty
                                  ? 0
                                  : 20.0,
                              child: _cardValidate
                                  ? _errorMessage.isNotEmpty
                                      ? Text(
                                          _errorMessage,
                                          style: TextStyle(
                                            color: theme.onError,
                                          ),
                                        )
                                      : null
                                  : Text(
                                      "A deck must contain at least 1 card!",
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
                                EvaIcons.editOutline,
                                color: Color(0xff08913F),
                              ),
                              onPressed: editDeck,
                              label: const Text(
                                "Edit Deck",
                                style: TextStyle(color: Color(0xff08913F)),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xffA9EDC4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //
                // List of cards created
                //
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: theme.surface,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return EditCard(
                                                front: cards[index]["front"],
                                                back: cards[index]["back"],
                                                cardId: cards[index]["cardId"],
                                                deckId: deckid,
                                                updateCardList: updateCardList,
                                              );
                                            },
                                          );
                                        },
                                        title: Text(
                                          '${cards[index]["front"]}',
                                          style: TextStyle(
                                            color: theme.primary,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${cards[index]["back"]}',
                                          style: TextStyle(
                                            color: theme.secondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          setState(() {
                                            cardId = cards[index]["cardId"];
                                            deleteCard();
                                          });
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: EvaIcons.trashOutline,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                );
                              },
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
