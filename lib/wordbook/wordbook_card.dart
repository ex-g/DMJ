import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/wordbook/word_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WordbookCard extends StatefulWidget {
  final String name;
  final String userId;
  final int count;
  final int basicTurn;

  const WordbookCard({
    super.key,
    required this.name,
    required this.userId,
    required this.count,
    required this.basicTurn,
  });

  @override
  State<WordbookCard> createState() => _WordbookCardState();
}

class _WordbookCardState extends State<WordbookCard> {
  // 파이어베이스 콜렉션 참조
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Basic Words");
  CollectionReference<Map<String, dynamic>> collectionReference2 =
      FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    // 미디어쿼리
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return GestureDetector(
      onTap: widget.name != "Basic Words"
          ? () async {
              QuerySnapshot<Map<String, dynamic>> querySnapshot =
                  await collectionReference2
                      .doc(widget.userId)
                      .collection("userWordbook")
                      .doc(widget.name)
                      .collection("Words")
                      .get();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WordListScreen(
                            basicTurn: widget.basicTurn,
                            count: widget.count,
                            querySnapshot: querySnapshot,
                            title: widget.name,
                            userId: widget.userId,
                          )));
            }
          : () async {
              QuerySnapshot<Map<String, dynamic>> querySnapshot =
                  await collectionReference
                      .doc("Turn1")
                      .collection("Words")
                      .get();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WordListScreen(
                            basicTurn: widget.basicTurn,
                            count: widget.count,
                            querySnapshot: querySnapshot,
                            title: widget.name,
                            userId: widget.userId,
                          )));
            },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                offset: Offset(2, 2),
                blurRadius: 4,
              )
            ]),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.02, horizontal: width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.text_fields_sharp,
                        size: 14,
                      ),
                      const SizedBox(width: 10),
                      widget.name != "Basic Words"
                          ? Text(
                              "${widget.count}",
                              style: const TextStyle(fontSize: 12),
                            )
                          : const Text(
                              "1800",
                              style: TextStyle(fontSize: 12),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                widget.name != "Basic Words"
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    title: Text(
                                      '단어장을 삭제하시겠습니까?',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    content: const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('예'),
                                        onPressed: () {
                                          // 단어장 삭제
                                          collectionReference2
                                              .doc(widget.userId)
                                              .collection("userWordbook")
                                              .doc(widget.name)
                                              .delete();

                                          // 단어장 하위 콜렉션 삭제
                                          collectionReference2
                                              .doc(widget.userId)
                                              .collection("userWordbook")
                                              .doc(widget.name)
                                              .collection("Words")
                                              .get()
                                              .then((value) => {
                                                    for (var i in value.docs)
                                                      {
                                                        collectionReference2
                                                            .doc(widget.userId)
                                                            .collection(
                                                                "userWordbook")
                                                            .doc(widget.name)
                                                            .collection("Words")
                                                            .doc(i[
                                                                'eng']) // value.docs는 랜덤순서이고 doc 이름이 영어로 되어 있으므로 i번째의 영어 이름을 지운다.

                                                            .delete()
                                                      }
                                                  });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('아니오'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ));
                        },
                        icon: const Icon(Icons.delete, size: 20),
                        color: Colors.grey,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text(
                              "Turn",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              "${widget.basicTurn}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
