import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/wordbook/word_model.dart';
import 'package:flutter/material.dart';

class WordListScreen extends StatefulWidget {
  final QuerySnapshot querySnapshot;
  final String title, userId;
  final int count;

  const WordListScreen(
      {super.key,
      required this.querySnapshot,
      required this.title,
      required this.userId,
      required this.count});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  final List<String> items = [];
  final saved = <Word>{};

  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Basic Words");
  CollectionReference<Map<String, dynamic>> collectionReference2 =
      FirebaseFirestore.instance.collection("Users");

  TextEditingController engController = TextEditingController();
  TextEditingController korController = TextEditingController();
  TextEditingController engSentenceController = TextEditingController();
  TextEditingController korSentenceController = TextEditingController();

  var len = 0;
  Future<void> addItemEvent(BuildContext context) {
    // 다이얼로그 폼 열기
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            '단어 추가하기',
            style: TextStyle(
                color: Theme.of(context).appBarTheme.backgroundColor,
                fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: engController,
                decoration: const InputDecoration(
                  labelText: '단어',
                ),
              ),
              TextField(
                controller: korController,
                decoration: const InputDecoration(
                  labelText: '뜻',
                ),
              ),
              TextField(
                controller: engSentenceController,
                decoration: const InputDecoration(
                  labelText: '영어 예시',
                ),
              ),
              TextField(
                controller: korSentenceController,
                decoration: const InputDecoration(
                  labelText: '한국어 예시',
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
                  collectionReference2
                      .doc(widget.userId)
                      .collection("userWordbook")
                      .doc(widget.title)
                      .update({"count": len + 1});

                  String eng = engController.text;
                  String kor = korController.text;
                  String engSentence = engSentenceController.text;
                  String korSentence = korSentenceController.text;

                  collectionReference2
                      .doc(widget.userId)
                      .collection("userWordbook")
                      .doc(widget.title)
                      .collection("Words")
                      .doc(eng)
                      .set({
                    "eng": eng,
                    "kor": kor,
                    "engSentence": engSentence,
                    "korSentence": korSentence,
                    "timestamp": DateTime.now(),
                  });

                  engController.text = "";
                  korController.text = "";
                  engSentenceController.text = "";
                  korSentenceController.text = "";
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      backgroundColor: Theme.of(context).cardColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: widget.title != "Basic Words"
                    ? collectionReference2
                        .doc(widget.userId)
                        .collection("userWordbook")
                        .doc(widget.title)
                        .collection("Words")
                        .orderBy("timestamp")
                        .snapshots()
                    : collectionReference.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    final docs = snapshot.data!.docs;

                    len = docs.length;
                    return ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: docs.length,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const Divider(
                        height: 20.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return widget.title != "Basic Words"
                            ? Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      border: Border.all(
                                        width: 0.5,
                                      ),
                                    ),
                                    child: SizedBox(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 4,
                                            child: SizedBox(
                                              height: 80,
                                              child: Center(
                                                child: Text(
                                                  docs[index]['eng'],
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 4,
                                            child: SizedBox(
                                              height: 80,
                                              child: Center(
                                                child: Text(
                                                  docs[index]['kor'],
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                child: Column(
                                  children: [
                                    Text("${docs[index]['title']}"),
                                    StreamBuilder(
                                      stream: collectionReference
                                          .doc("${docs[index]['title']}")
                                          .collection("Words")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          final docs2 = snapshot.data!.docs;
                                          return ListView.separated(
                                            padding: const EdgeInsets.all(20),
                                            itemCount: docs2.length,
                                            shrinkWrap: true,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const Divider(
                                              height: 20.0,
                                            ),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                  border: Border.all(
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: SizedBox(
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        flex: 4,
                                                        child: SizedBox(
                                                          height: 80,
                                                          child: Center(
                                                            child: Text(
                                                              docs2[index]
                                                                  ['eng'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 4,
                                                        child: SizedBox(
                                                          height: 80,
                                                          child: Center(
                                                            child: Text(
                                                              docs2[index]
                                                                  ['kor'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                    )
                                  ],
                                ),
                              );
                      },
                    );
                  }
                },
              ),
              widget.title != "Basic Words"
                  ? Transform.translate(
                      offset: const Offset(0, -20),
                      child: FloatingActionButton(
                          backgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          hoverColor: Theme.of(context).cardColor,
                          child: const Icon(Icons.add),
                          onPressed: () => addItemEvent(context)))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
