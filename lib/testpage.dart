import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/makepostpage.dart';
import 'package:dmj/run/flipcard.dart';
import 'package:dmj/wordbook/wordbook_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");

  List<dynamic> lst = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("테스트페이지"),
      ),
      body: SizedBox(
        height: 500,
        width: 320,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                var snapshots = collectionReference
                    .doc("2e6Ohz9LQ7UY3yqAZVk7U2X9DYq1")
                    .get()
                    .then((value) {
                  print(value.data()?["money"]);
                });
              },
              child: Container(

                  // snapshots.forEach((element) {
                  //   print(element.docs);
                  //   var ninewords = element.docs.toList();
                  //   print(ninewords);
                  //   // print(b[0]['eng']);
                  //   // print(element.docs.toList()[0]['eng']);
                  // });

                  child: const Text("데이터 가져오기")),
            ),
            ElevatedButton(
              onPressed: () {
                collectionReference.doc('새로운 단어장').set({"title": "새로운 단어장"});
              },
              child: const Text("새로운 단어장 만들기"),
            ),
            ElevatedButton(
              onPressed: () {
                collectionReference
                    .doc('새로운 단어장')
                    .update({"title": "새로운 단어장2"});
              },
              child: const Text("단어장 제목 업데이트"),
            ),
            ElevatedButton(
              onPressed: () {
                collectionReference.doc('새로운 단어장').delete();
              },
              child: const Text("단어장 삭제"),
            ),
            const SizedBox(height: 40),
            const SizedBox(height: 50),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(
                  height: 50,
                  width: 20,
                  color: Colors.amber,
                  child: Text("hi$index"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
