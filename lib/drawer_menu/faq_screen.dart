import 'package:flutter/material.dart';

class faqScreen extends StatefulWidget {
  const faqScreen({super.key});

  @override
  State<faqScreen> createState() => _faqScreenState();
}

makeFAQ(question, answer) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text(
          question,
          style: const TextStyle(
              color: Color(0xFF86A845),
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          answer,
          style: const TextStyle(fontSize: 13, height: 1.7),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(child: Divider(color: Colors.grey, thickness: 1)),
      ),
      const SizedBox(height: 10),
    ],
  );
}

class _faqScreenState extends State<faqScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("FAQ",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontWeight: FontWeight.bold))),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              makeFAQ("1. 어떻게 코인을 얻을 수 있나요?", """현재 지단이 앱에서 제공 중인 코인 획득 방식은, 
Run 화면에서 경로 카드 설정 후 
단어 암기 > 테스트 > 뽑기를 통한 방식입니다.
\n뽑기 화면의 카드 뒷면에 적힌 숫자만큼 코인 획득이 가능하며, 카드 배치는 랜덤입니다.
"""),
              makeFAQ("2. 옷 환불 가능한가요?", """
한 번 잠금해제된 코스튬은 환불이 불가능합니다.
단어 테스트를 통해 코인을 더 얻을 수 있습니다.
"""),
              makeFAQ("3. 영단어 난이도 조절 가능한가요?", """
현재 지단이 어플에서 기본적으로 제공되는 Basic Words 단어장의 경우,
토익(TOEIC) 시험에 나오는 영단어 1800개를 선별하여 제공하고 있습니다.
\n더 쉽거나 어려운 난이도의 단어로 학습을 원하신다면, 
Wordbook 화면에서 플러스 버튼을 통해 '나의 단어장'을 만들 수 있습니다.
"""),
              makeFAQ("4. 단어 학습 과정이 궁금해요.", """
현재 Run 화면에서 경로 카드를 클릭했을 때 제공되는 단어 학습은,
한 역 당 3개의 단어를 외우는 시스템입니다.
\n3개 역 마다 9개 단어에 대한 테스트가 준비되어 있으며,
테스트를 마치고 카드 뽑기를 통해 코인을 획득할 수 있습니다.
""")
            ],
          ),
        ));
  }
}
