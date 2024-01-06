import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/accounts/login_google.dart';
import 'package:dmj/wordbook/wordbook_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WordbookScreen extends StatefulWidget {
  const WordbookScreen({
    super.key,
  });

  @override
  State<WordbookScreen> createState() => _WordbookScreenState();
}

class _WordbookScreenState extends State<WordbookScreen> {
  // 파이어베이스 콜렉션 참조
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Basic Words");
  CollectionReference<Map<String, dynamic>> collectionReference2 =
      FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    // 변수 선언
    final TextEditingController titleController = TextEditingController();
    TextEditingController turnEditController = TextEditingController();
    // 미디어쿼리
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "WORDBOOK",
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: WordbookCard(
                          name: "Basic Words",
                          userId: "",
                          count: 1800,
                          basicTurn: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "로그인 후 단어장을 추가해보세요!",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .appBarTheme
                                  .backgroundColor),
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
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor)),
                          child: const Text(
                            "로그인",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  var uid = snapshot.data!.uid;
                  return Column(
                    children: [
                      StreamBuilder(
                          stream: collectionReference2.doc(uid).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              var basicTurn = snapshot.data!['basicTurn'];
                              return Column(
                                children: [
                                  SizedBox(height: width * 0.05),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: WordbookCard(
                                          name: "Basic Words",
                                          userId: "",
                                          count: 1800,
                                          basicTurn: basicTurn,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: IconButton(
                                          icon: const Icon(Icons.change_circle),
                                          onPressed: () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                title: Text(
                                                  "학습할 턴 수정하기",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .appBarTheme
                                                          .backgroundColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "수정한 턴부터 학습을 다시 시작합니다.",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.blue),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("현재 턴: $basicTurn"),
                                                    TextField(
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  '수정할 턴',
                                                              hintText:
                                                                  "1~현재 턴 사이의 숫자 입력"),
                                                      controller:
                                                          turnEditController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(
                                                          RegExp('[0-9]'),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        turnEditController
                                                            .text = "";
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text("취소")),
                                                  TextButton(
                                                    child: const Text("수정"),
                                                    onPressed: () {
                                                      var editTurn = int.parse(
                                                          turnEditController
                                                              .text);
                                                      if (editTurn > 0 &&
                                                          editTurn <
                                                              basicTurn) {
                                                        collectionReference2
                                                            .doc(uid)
                                                            .update({
                                                          "basicTurn": editTurn
                                                        });

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              "턴이 수정되었습니다."),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  1000),
                                                        ));
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                "숫자를 다시 입력해주세요."),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    1000),
                                                          ),
                                                        );
                                                      }
                                                      turnEditController.text =
                                                          "";
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            child: Divider(
                                                color: Colors.grey,
                                                thickness: 1.5)),
                                        SizedBox(height: 10),
                                        Text(
                                          "내 단어장",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  StreamBuilder(
                                      stream: collectionReference2
                                          .doc(uid)
                                          .collection("userWordbook")
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<
                                                  QuerySnapshot<
                                                      Map<String, dynamic>>>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }
                                        final docs = snapshot.data!.docs;
                                        return SizedBox(
                                          child: ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              separatorBuilder:
                                                  (context, index) => Divider(
                                                      height: height * 0.03,
                                                      color: Colors.grey),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 15, 15),
                                              itemCount: docs.length,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return WordbookCard(
                                                  name: docs[index]['title'],
                                                  userId: uid,
                                                  count: docs[index]['count'],
                                                  basicTurn: 0,
                                                );
                                              }),
                                        );
                                      }),
                                  FloatingActionButton(
                                    onPressed: () => showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            title: Text(
                                              '새 단어장 만들기',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .appBarTheme
                                                      .backgroundColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                TextField(
                                                  controller: titleController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: '단어장 이름',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('취소'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('추가'),
                                                onPressed: () {
                                                  setState(() {
                                                    String newName =
                                                        titleController.text;
                                                    collectionReference2
                                                        .doc(uid)
                                                        .collection(
                                                            "userWordbook")
                                                        .doc(newName)
                                                        .set({
                                                      "title": newName,
                                                      "count": 0
                                                    });
                                                    titleController.text = "";
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        }),
                                    backgroundColor: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                    hoverColor:
                                        Theme.of(context).highlightColor,
                                    child: const Icon(Icons.add),
                                  )
                                ],
                              );
                            }
                          }),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
