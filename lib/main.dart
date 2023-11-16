import 'package:dmj/history/history_screen.dart';
import 'package:dmj/home/home_screen.dart';
import 'package:dmj/run/run_screen.dart';
import 'package:dmj/wordbook/wordbook_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
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
  int _currentIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const RunScreen(),
    const WordbookScreen(),
    const HistoryScreen(),
  ];
  void _onItemTapped(int index) {
    setState(
      () {
        _currentIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        cardColor: const Color(0xFFFFB937),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF6B8A47),
        ),
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFFFDEBC8),
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: _pages.elementAt(_currentIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF6B8A47),
          unselectedItemColor: const Color(0xFFFDEBC8),
          selectedIconTheme: const IconThemeData(color: Color(0xFFFFB937)),
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
          selectedItemColor: const Color(0xFFFFB937),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
