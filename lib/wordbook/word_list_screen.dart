import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WordListScreen extends StatefulWidget {
  final QuerySnapshot querySnapshot;
  final String title, userId;
  final int count, basicTurn;

  const WordListScreen(
      {super.key,
      required this.querySnapshot,
      required this.title,
      required this.userId,
      required this.count,
      required this.basicTurn});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  // 파이어베이스 콜렉션 참조
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Basic Words");
  CollectionReference<Map<String, dynamic>> collectionReference2 =
      FirebaseFirestore.instance.collection("Users");
  // 변수 설정
  TextEditingController engController = TextEditingController();
  TextEditingController korController = TextEditingController();
  TextEditingController engSentenceController = TextEditingController();
  TextEditingController korSentenceController = TextEditingController();
  TextEditingController turnController = TextEditingController(text: "");

  var len = 0;
  var nowTurn = 1;

  // 단어 추가 다이얼로그 폼 열기
  Future<void> addItemEvent(BuildContext context) {
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
      body: SingleChildScrollView(
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
                  : collectionReference
                      .doc("Turn$nowTurn")
                      .collection("Words")
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  final docs = snapshot.data!.docs;
                  len = docs.length;
                  return Column(
                    children: [
                      widget.title == "Basic Words"
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (nowTurn == 1) {
                                                nowTurn = 1;
                                              } else {
                                                nowTurn--;
                                              }
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.navigate_before)),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: turnController,
                                          decoration: const InputDecoration(
                                              hintText: "숫자 입력 ex) 57",
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          int val =
                                              int.parse(turnController.text);
                                          setState(() {
                                            if (val > 200) {
                                              nowTurn = 200;
                                            } else if (val < 1) {
                                              nowTurn = 1;
                                            } else {
                                              nowTurn = val;
                                            }
                                            turnController.text = "";
                                          });
                                        },
                                        icon: Icon(
                                          Icons.check_circle_outline,
                                          color: Theme.of(context)
                                              .appBarTheme
                                              .backgroundColor,
                                        )),
                                    Flexible(
                                      flex: 2,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (nowTurn == 200) {
                                                nowTurn = 200;
                                              } else {
                                                nowTurn++;
                                              }
                                            });
                                          },
                                          icon:
                                              const Icon(Icons.navigate_next)),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                    child: Divider(
                                        color: Colors.grey, thickness: 1.5)),
                                const SizedBox(height: 10),
                                Text(
                                  "Turn$nowTurn",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            )
                          : Container(),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        itemCount: docs.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(
                          height: 20.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      title: Text(
                                        docs[index]['eng'],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .appBarTheme
                                                .backgroundColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Eng",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("${docs[index]['engSentence']}"),
                                          const SizedBox(height: 10),
                                          const Text(
                                            "Kor",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("${docs[index]['korSentence']}"),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                child: Container(
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
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 10),
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
    );
  }
}
