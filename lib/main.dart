import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/history/history_screen.dart';
import 'package:dmj/home/home_screen.dart';
import 'package:dmj/run/run_screen.dart';
import 'package:dmj/wordbook/wordbook_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// void _isolateMain(RootIsolateToken rootIsolateToken) async {
//   BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
// }

void main() async {
  // RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  // Isolate.spawn(_isolateMain, rootIsolateToken);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );

  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("WordbookList");
  int _currentIndex = 0;
  late List<String> items = ["hi"];
  int a = 1;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const HomeScreen(),
      const RunScreen(),
      const WordbookScreen(),
      const HistoryScreen(),
    ];
    return MaterialApp(
      theme: ThemeData(
        highlightColor: const Color(0xFFF9E36F),
        cardColor: const Color(0xFFF1EDD6),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF86A845),
        ),
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFFFCFBF7),
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: pages.elementAt(_currentIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF86A845),
          unselectedItemColor: const Color(0xFFFCFBF7),
          selectedIconTheme: const IconThemeData(color: Color(0xFFF9E36F)),
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.subway_outlined),
              label: 'RUN',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'WORDBOOK',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'HISTORY',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFFF9E36F),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
