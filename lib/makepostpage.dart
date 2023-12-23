import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MakePostPage extends StatefulWidget {
  const MakePostPage({super.key});

  @override
  State<MakePostPage> createState() => _MakePostPageState();
}

class _MakePostPageState extends State<MakePostPage> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String postTitle = "";
  String postContent = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("포스트 업로드 테스트"),
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "포스팅 제목",
              ),
              onChanged: (value) {
                setState(() {
                  postTitle = value;
                });
              },
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "포스팅 내용",
              ),
              maxLines: 10,
              onChanged: (value) {
                setState(() {
                  postContent = value;
                });
              },
            ),
            ElevatedButton(
                onPressed: () {
                  fireStore.collection("Posts").doc('apple').delete();
                },
                child: const Text("삭제하기"))
          ],
        ),
      ),
    );
  }
}
