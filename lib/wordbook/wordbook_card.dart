import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/wordbook/word_list_screen.dart';
import 'package:dmj/wordbook/word_model.dart';
import 'package:flutter/material.dart';

class WordbookCard extends StatefulWidget {
  final String name;
  final String userId;
  final int count;

  const WordbookCard({
    super.key,
    required this.name,
    required this.userId,
    required this.count,
  });

  @override
  State<WordbookCard> createState() => _WordbookCardState();
}

class _WordbookCardState extends State<WordbookCard> {
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Basic Words");
  CollectionReference<Map<String, dynamic>> collectionReference2 =
      FirebaseFirestore.instance.collection("Users");

  TextEditingController titleEditingController = TextEditingController();

  // Future<void> editWordbookName(BuildContext context) {
  //   // 다이얼로그 폼 열기
  //   return showDialog<void>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           backgroundColor: Theme.of(context).colorScheme.background,
  //           title: Text(
  //             '단어장 이름 변경',
  //             style: TextStyle(
  //                 color: Theme.of(context).appBarTheme.backgroundColor,
  //                 fontWeight: FontWeight.bold),
  //           ),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               TextField(
  //                 controller: titleEditingController,
  //                 decoration: const InputDecoration(
  //                   labelText: '단어장 이름',
  //                 ),
  //               ),
  //             ],
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('취소'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //               child: const Text('수정'),
  //               onPressed: () {
  //                 setState(() {
  //                   String newName = titleEditingController.text;
  //                   collectionReference
  //                       .doc(widget.name)
  //                       .update({"title": newName});
  //                   // titleEditingController.text =;
  //                 });
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
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

              print(querySnapshot);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WordListScreen(
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
        width: width * 0.8,
        height: height * 0.16,
        child: Row(
          children: [
            const SizedBox(width: 20),
            Flexible(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(
                        Icons.text_fields_sharp,
                        size: 14,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "0",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text("/"),
                      Text(
                        // "${words.snapshots().length}",
                        "9",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Flexible(
            //   flex: 2,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       IconButton(
            //         onPressed: () => editWordbookName(context),
            //         icon:
            //             const Icon(Icons.mode_edit_outline_outlined, size: 20),
            //       ),
            //       const SizedBox(height: 15),
            //     ],
            //   ),
            // )
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  const SizedBox(width: 15),
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
                                                              .doc(
                                                                  widget.userId)
                                                              .collection(
                                                                  "userWordbook")
                                                              .doc(widget.name)
                                                              .collection(
                                                                  "Words")
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
                      : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
