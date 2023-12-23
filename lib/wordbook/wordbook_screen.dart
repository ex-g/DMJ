import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/accounts/login_google.dart';
import 'package:dmj/wordbook/wordbook_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WordbookScreen extends StatefulWidget {
  const WordbookScreen({
    super.key,
  });

  @override
  State<WordbookScreen> createState() => _WordbookScreenState();
}

class _WordbookScreenState extends State<WordbookScreen> {
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Basic Words");
  CollectionReference<Map<String, dynamic>> collectionReference2 =
      FirebaseFirestore.instance.collection("Users");

  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Column(
                        children: [
                          const WordbookCard(
                            name: "Basic Words",
                            userId: "",
                            count: 1800,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "로그인 후 단어장을 추가해보세요!",
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
                          )
                        ],
                      );
                    } else {
                      var uid = snapshot.data!.uid;
                      return Column(
                        children: [
                          const WordbookCard(
                            name: "Basic Words",
                            userId: "",
                            count: 1800,
                          ),
                          const SizedBox(height: 20),
                          const Text("내 단어장"),
                          StreamBuilder(
                              stream: collectionReference2
                                  .doc(snapshot.data!.uid)
                                  .collection("userWordbook")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                final docs = snapshot.data!.docs;
                                return SizedBox(
                                  height: height * 0.8 + 20,
                                  child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const Divider(
                                            height: 20.0,
                                          ),
                                      padding: const EdgeInsets.all(10),
                                      itemCount: docs.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return WordbookCard(
                                          name: docs[index]['title'],
                                          userId: uid,
                                          count: docs[index]['count'],
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
                                          decoration: const InputDecoration(
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
                                                .doc(snapshot.data!.uid)
                                                .collection("userWordbook")
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
                            backgroundColor:
                                Theme.of(context).appBarTheme.backgroundColor,
                            hoverColor: Theme.of(context).highlightColor,
                            child: const Icon(Icons.add),
                          )
                        ],
                      );
                    }
                  }),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
