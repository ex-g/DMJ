import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var switchValue = false;
  @override
  Widget build(BuildContext context) {
    Widget makeSetting(String settingText) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          border: Border.fromBorderSide(
            BorderSide(
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 80,
        child: Row(
          children: [
            const SizedBox(width: 30),
            Text(
              settingText,
              style: TextStyle(
                color: Theme.of(context).cardColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            // GestureDetector(
            //     onTap: () {
            //       showDialog(
            //           context: context,
            //           builder: (context) {
            //             return SimpleDialog(
            //               title: const Text("다크 모드로 변경하시겠습니까?"),
            //               children: [
            //                 TextButton(
            //                   child: const Text("예"),
            //                   onPressed: () {
            //                     Navigator.pop(context);
            //                   },
            //                 ),
            //                 TextButton(
            //                   child: const Text("아니오"),
            //                   onPressed: () {
            //                     Navigator.pop(context);
            //                   },
            //                 ),
            //               ],
            //             );
            //           });
            //     },
            //     child: makeSetting("Dark Mode")),
            makeSetting("Send FeedBack"),
            makeSetting("Share"),
            makeSetting("Privacy Policy"),
          ],
        ),
      ),
    );
  }
}
