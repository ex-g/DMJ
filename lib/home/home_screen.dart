import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/accounts/login_google.dart';
import 'package:dmj/home/shop.dart';
import 'package:dmj/setting/setting_screen.dart';
import 'package:dmj/testpage.dart';
import 'package:dmj/wordbook/wordbook_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");
  List<String> clothes = [
    'assets/images/character.jpg',
    'assets/images/top1.png',
    'assets/images/top2.png',
    'assets/images/top3.png',
    'assets/images/top4.png',
    'assets/images/top5.png',
    'assets/images/top6.png',
  ];

  int _currentIndex = 1;

  void _onItemTapped() {
    if (_currentIndex < 6) {
      setState(
        () {
          _currentIndex = _currentIndex + 1;
        },
      );
    } else {
      setState(() {
        _currentIndex = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TestPage()));
          },
          child: Text(
            "HOME",
            style: TextStyle(
              color: Theme.of(context).colorScheme.background,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    alignment: Alignment.topRight,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.background),
                        child: Text(
                          "Words Basic",
                          style: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.background),
                        child: Text("Settings",
                            style: TextStyle(
                              color: Theme.of(context).cardColor,
                              fontSize: 15,
                            )),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Stack(
        children: [
          StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Stack(
                    children: [
                      Transform.translate(
                        offset: const Offset(20, 0),
                        child: Transform.scale(
                          scale: 1.2,
                          child: Image.asset(
                            clothes[0],
                            width: width * 1,
                            height: height * 1,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LogIn()));
                          },
                          child: const Text("로그인"),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Stack(
                    children: [
                      Transform.translate(
                        offset: const Offset(20, 0),
                        child: Transform.scale(
                          scale: 1.2,
                          child: Image.asset(clothes[0]),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(12, 115),
                        child: Transform.scale(
                          scale: 1.9,
                          child: Image.asset(clothes[_currentIndex]),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: FloatingActionButton(
                          onPressed: _onItemTapped,
                          backgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          child: const Icon(Icons.play_arrow),
                        ),
                      )
                    ],
                  );
                }
              }),
        ],
      ),
    );
  }
}
