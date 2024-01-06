import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/drawer_menu/faq_screen.dart';
import 'package:dmj/drawer_menu/intro_screen.dart';
import 'package:dmj/home/shop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 파이어베이스 - Users 콜렉션 참조
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");

  // // 구글 로그인 (웹)
  // Future<UserCredential?> signInWithGoogle() async {
  //   // Create a new provider
  //   GoogleAuthProvider googleProvider = GoogleAuthProvider();

  //   googleProvider
  //       .addScope('https://www.googleapis.com/auth/contacts.readonly');
  //   googleProvider.addScope("https://www.googleapis.com/auth/calendar");
  //   googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  //   // Once signed in, return the UserCredential
  //   UserCredential user =
  //       await FirebaseAuth.instance.signInWithPopup(googleProvider);

  //   // 처음이면 계정 만들기, 아니면 패스
  //   var userLastLoginTime = user.user!.metadata.lastSignInTime;
  //   var userCreationTime = user.user!.metadata.creationTime;

  //   if (userLastLoginTime == userCreationTime) {
  //     collectionReference.doc(user.user?.uid).set({
  //       "username": "${user.user?.displayName}",
  //       "id": user.user?.uid,
  //       "character": "basic",
  //       "money": 0,
  //       "basicTurn": 1
  //     });

  //     collectionReference
  //         .doc(user.user?.uid)
  //         .collection("dayStamp")
  //         .doc("1")
  //         .set({"date": "start"});

  //     for (var i = 1; i < 7; i++) {
  //       collectionReference
  //           .doc(user.user?.uid)
  //           .collection('closet')
  //           .doc('top$i')
  //           .set({
  //         "isChecked": false,
  //         "name": "top$i",
  //         "own": false,
  //         "price": i * 10000,
  //       });
  //     }
  //   }

  //   return user;
  // }

  // 구글 로그인 (Android & IOS)
  Future<UserCredential> signInWithGoogle() async {
    print("hi");
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final user = await FirebaseAuth.instance.signInWithCredential(credential);

    // 처음이면 계정 만들기, 아니면 패스
    var userLastLoginTime = user.user!.metadata.lastSignInTime;
    var userCreationTime = user.user!.metadata.creationTime;

    if (userLastLoginTime == userCreationTime) {
      collectionReference.doc(user.user?.uid).set({
        "username": "${user.user?.displayName}",
        "id": user.user?.uid,
        "character": "basic",
        "money": 0,
        "basicTurn": 1
      });

      collectionReference
          .doc(user.user?.uid)
          .collection("dayStamp")
          .doc("1")
          .set({"date": "start"});

      for (var i = 1; i < 7; i++) {
        collectionReference
            .doc(user.user?.uid)
            .collection('closet')
            .doc('top$i')
            .set({
          "isChecked": false,
          "name": "top$i",
          "own": false,
          "price": i * 10000,
        });
      }
    }

    return user;
  }

// ----------------------
// 시작점
// ----------------------

  @override
  Widget build(BuildContext context) {
    // 미디어쿼리 스크린사이즈
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "HOME",
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      endDrawer: Drawer(
        child: StatefulBuilder(
          builder: (context, setState) {
            return ListView(
              children: [
                StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    late String? userName = "";
                    late String? userEmail = "";
                    if (!snapshot.hasData) {
                      userName = "반갑습니다!";
                      userEmail = "로그인을 해주세요";
                    } else {
                      if (snapshot.data!.displayName!.length < 4) {
                        userName = snapshot.data!.displayName!;
                      } else {
                        userName = snapshot.data!.displayName!.substring(0, 4);
                      }
                      userEmail = snapshot.data!.email;
                    }
                    return DrawerHeader(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Transform.scale(
                                  scale: 2,
                                  child: Image.asset(
                                    'assets/images/profile.jpg',
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background),
                                  ),
                                  Text(
                                    "$userEmail",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: userName == "반갑습니다!"
                                ? () {
                                    signInWithGoogle();
                                  }
                                : () {
                                    FirebaseAuth.instance.signOut();
                                  },
                            child: Text(
                              userName == "반갑습니다!" ? "로그인" : "로그아웃",
                              style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.menu_book),
                    title: const Text("'지단이' 소개"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const IntroScreen()));
                    }),
                ListTile(
                    leading: const Icon(Icons.question_mark),
                    title: const Text("FAQ"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const faqScreen()));
                    }),
                GestureDetector(
                  child: ListTile(
                      onTap: () => showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                  title: Text(
                                    "문의하기",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  content: const Text(
                                    """'지단이' 앱과 관련된 문의 및 피드백은 아래 이메일로 부탁드립니다.
\nex_g@hufs.ac.kr""",
                                    style: TextStyle(fontSize: 14),
                                  ));
                            });
                          }),
                      leading: const Icon(
                        Icons.headset_mic_sharp,
                      ),
                      title: const Text("문의하기")),
                ),
              ],
            );
          },
        ),
      ),
      body: PopScope(
        canPop: false,
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // 로그인 여부
            if (!snapshot.hasData) {
              return Stack(
                children: [
                  Image.asset(
                    'assets/images/subway.png',
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/images/char_basic.png',
                      height: height * 0.75,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 20),
                      child: IconButton(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        hoverColor: Theme.of(context).highlightColor,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Shop()));
                        },
                        icon: const Icon(
                          Icons.shopping_bag,
                          size: 40,
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else {
              var userId = snapshot.data!.uid;
              return StreamBuilder(
                stream: collectionReference.doc(userId).snapshots(),
                builder: (context, snapshot) {
                  var addr = 'basic';
                  if (!snapshot.hasData) {
                  } else {
                    addr = snapshot.data!['character'];
                  }
                  return Stack(
                    children: [
                      Image.asset(
                        'assets/images/subway.png',
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'assets/images/char_$addr.png',
                          height: height * 0.75,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 20),
                          child: IconButton(
                            color:
                                Theme.of(context).appBarTheme.backgroundColor,
                            hoverColor: Theme.of(context).highlightColor,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Shop()));
                            },
                            icon: const Icon(
                              Icons.shopping_bag,
                              size: 40,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
