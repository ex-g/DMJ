import 'package:dmj/setting/setting_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> clothes = ['assets/images/character.jpg', ''];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "HOME",
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
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
      body: Center(
        child: Image.asset(clothes[0]),
      ),
    );
  }
}
