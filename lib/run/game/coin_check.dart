import 'package:dmj/main.dart';
import 'package:dmj/run/running_screen.dart';
import 'package:flutter/material.dart';

class CoinCheck extends StatefulWidget {
  int totalTurn, nowTurn, coinSum, money, basicTurn;
  String title, wordbook, userId;
  CoinCheck({
    super.key,
    required this.coinSum,
    required this.nowTurn,
    required this.totalTurn,
    required this.title,
    required this.wordbook,
    required this.basicTurn,
    required this.money,
    required this.userId,
  });

  @override
  State<CoinCheck> createState() => _RewardState();
}

var money = 0;

class _RewardState extends State<CoinCheck> {
  List<int> randomLst = [];
  @override
  Widget build(BuildContext context) {
    // 미디어쿼리 스크린사이즈
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reward",
          style: TextStyle(color: Colors.white),
        ),
        leading: Container(),
      ),
      body: PopScope(
        canPop: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/coin.png',
                      width: 80,
                      height: 80,
                    ),
                    Text(
                      "${widget.coinSum} coin!",
                      style: TextStyle(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.1),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Total Coin : ${widget.money}",
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ),
              SizedBox(height: height * 0.1),
              FloatingActionButton(
                backgroundColor: const Color(0xFF86A845),
                child: const Icon(Icons.play_arrow),
                onPressed: () {
                  if (widget.nowTurn == widget.totalTurn) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RunningScreen(
                          money: widget.money,
                          randomList: randomLst,
                          basicTurn: widget.basicTurn,
                          wordbook: widget.wordbook,
                          nowTurn: widget.nowTurn + 1,
                          totalTurn: widget.totalTurn,
                          title: widget.title,
                          userId: widget.userId,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
