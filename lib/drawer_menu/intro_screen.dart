import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("'지단이' 소개",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontWeight: FontWeight.bold))),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "1. Why",
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  """오늘도 지친 얼굴로 지하철에 탑승한 당신. 
때때로 열심히 살아도 뒤쳐지는 기분이 들지 않나요?
\n능력이 부족하다고 생각되는 하루. 
자신감도 떨어지고 우울한 마음이 들어요.
\n-
\n단어를 외울수록 힘이 생기는 당신!
지하철에서의 자투리 시간을 모아 당신의 꿈을 향한 시간으로!
한 단어씩 차근차근 외우면 자신감 up 
\n점차 밝아지는 당신의 표정과 마음대로 고를 수 있는 코스튬들!
지식과 자산을 모두 겸비한 능력자가 될 그날까지 지단이와 함께 도약해봐요!\n""",
                  style: TextStyle(fontSize: 15, height: 2.2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child:
                    SizedBox(child: Divider(color: Colors.grey, thickness: 1)),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  "2. How",
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  """▶ Home
- 나만의 캐릭터를 확인해 보세요.
- 상점에서 코스튬을 구매할 수 있습니다.
- 우측 상단에서 계정 정보를 확인할 수 있습니다.

\n▶ Run
- 출발역 & 도착역 설정 후 경로 카드를 만들어보세요.
- 단어는 한 역 당 3개씩 플립카드 형태로 제공됩니다.
- 3개의 역마다 테스트가 준비되어 있습니다.
- 테스트 후 얻게 되는 코인으로 코스튬 구매가 가능합니다.

\n▶ Wordbook
- 전체 단어가 목록 형식으로 제공됩니다.
- 플러스 버튼을 눌러 '나만의 단어장'을 만들어보세요!
- Basic Words 단어장의 단어는 턴 별로 제공됩니다.

\n▶ History
- 달력 위젯에서 출석한 날을 확인할 수 있습니다.
- 출석 기준은 9개 단어 암기 및 테스트 완료입니다.
                  """,
                  style: TextStyle(fontSize: 15, height: 2.2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child:
                    SizedBox(child: Divider(color: Colors.grey, thickness: 1)),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  "3. Made by...",
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "한국외국어대학교 중앙창업동아리 huve 팀 '지단이'\n",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ));
  }
}
