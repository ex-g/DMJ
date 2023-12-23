import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/accounts/login_google.dart';
import 'package:dmj/history/static_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(children: [
          StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "로그인 후 프로필을 확인해보세요!",
                          style: TextStyle(color: Colors.blue),
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
                  print(collectionReference.doc(snapshot.data?.uid).get());
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person),
                            Column(children: [
                              Text("${snapshot.data?.displayName}님 반갑습니다."),
                            ])
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                            },
                            child: const Text("로그아웃"))
                      ],
                    ),
                  );
                }
              }),

          // const SizedBox(height: 10),
          // Container(
          //   decoration: const BoxDecoration(),
          //   clipBehavior: Clip.none,
          //   child: Transform.translate(
          //     offset: const Offset(-100, 0),
          //     child: Text(
          //       "Statics",
          //       style: TextStyle(
          //         fontWeight: FontWeight.w900,
          //         fontSize: 30,
          //         color: Theme.of(context).appBarTheme.backgroundColor,
          //       ),
          //     ),
          //   ),
          // ),
          // Container(
          //   width: 320,
          //   decoration: BoxDecoration(
          //       color: Theme.of(context).appBarTheme.backgroundColor,
          //       borderRadius: BorderRadius.circular(25)),
          //   child: TabBar(
          //     tabs: [
          //       Container(
          //         height: 30,
          //         alignment: Alignment.center,
          //         child: const Text(
          //           'Day',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //       Container(
          //           height: 30,
          //           alignment: Alignment.center,
          //           child: const Text(
          //             'Week',
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //             ),
          //           )),
          //       Container(
          //         height: 30,
          //         alignment: Alignment.center,
          //         child: const Text(
          //           'Month',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //       Container(
          //         height: 30,
          //         alignment: Alignment.center,
          //         child: const Text(
          //           'Year',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ],
          //     labelColor: Theme.of(context).cardColor,
          //     unselectedLabelColor: Theme.of(context).colorScheme.background,
          //     controller: _tabController,
          //   ),
          // ),
          // Expanded(
          //   child: TabBarView(
          //     controller: _tabController,
          //     children: [
          //       StaticCard(wordCount: "3개", time: "10m"),
          //       StaticCard(wordCount: "24개", time: "80m"),
          //       StaticCard(wordCount: "45개", time: "200m"),
          //       StaticCard(wordCount: "300개", time: "950m"),
          //     ],
          //   ),
          // )
        ]),
      ),
    );
  }
}
