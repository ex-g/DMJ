import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Map tops = {
  "top1": [true, false, 'assets/images/char_top1.png'],
  "top2": [true, false, 'assets/images/char_top2.png'],
  "top3": [true, false, 'assets/images/char_top3.png'],
  "top4": [true, false, 'assets/images/char_top4.png'],
  "top5": [true, false, 'assets/images/char_top5.png'],
  "top6": [true, false, 'assets/images/char_top6.png'],
};
String charAddr = "basic";
bool isFirst = true;
// 바지 아직 안 만들어져서 그냥 위로 빼둠.
makePantsContainer(height) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Container(
      width: height * 0.14,
      height: height * 0.14,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.lock,
        size: 30,
      ),
    ),
  );
}

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  // 파이어베이스 콜렉션 참조
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    // 미디어쿼리
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Shop",
        style: TextStyle(color: Colors.white),
      )),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 로그인 여부
          if (!snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset('assets/images/char_basic.png',
                              width: width * 0.4)),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            width: 80,
                            height: 30,
                            decoration: BoxDecoration(boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                              ),
                              BoxShadow(
                                  color: Colors.white,
                                  spreadRadius: -1.0,
                                  blurRadius: 2.0,
                                  offset: Offset(0, 3)),
                            ], borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/coin.png',
                                    width: 20,
                                  ),
                                  const Text(
                                    "0",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.024),
                  Container(
                    height: height * 0.17,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 236, 223, 184)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          makePantsContainer(height),
                          makePantsContainer(height),
                          makePantsContainer(height),
                          makePantsContainer(height),
                          makePantsContainer(height),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.024),
                  Container(
                    height: height * 0.17,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 236, 223, 184)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          makePantsContainer(height),
                          makePantsContainer(height),
                          makePantsContainer(height),
                          makePantsContainer(height),
                          makePantsContainer(height),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            var userId = snapshot.data!.uid;
            return StreamBuilder(
              stream: collectionReference.doc(userId).snapshots(),
              builder: (context, snapshot) {
                // 유저가 가지고 있는 콜렉션 + 필드 여부
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  var money = snapshot.data!['money'];
                  var prev = snapshot.data!['character'];

                  return StreamBuilder(
                    stream: collectionReference
                        .doc(userId)
                        .collection("closet")
                        .snapshots(),
                    builder: (context, snapshot) {
                      // 옷장 여부
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        var docs = snapshot.data!.docs;
                        Map ownList = {}; // 가지고 있는지
                        Map priceList = {}; // 금액 맵

                        for (var doc in docs) {
                          var docName = doc.data()['name'];
                          ownList[docName] = doc.data()['own'];
                          priceList[docName] = doc.data()['price'];
                        }

                        onTapContainer(tops, addr) {
                          if (ownList[addr] == false) {
                            tops = {
                              "top1": [
                                true,
                                false,
                                'assets/images/char_top1.png'
                              ],
                              "top2": [
                                true,
                                false,
                                'assets/images/char_top2.png'
                              ],
                              "top3": [
                                true,
                                false,
                                'assets/images/char_top3.png'
                              ],
                              "top4": [
                                true,
                                false,
                                'assets/images/char_top4.png'
                              ],
                              "top5": [
                                true,
                                false,
                                'assets/images/char_top5.png'
                              ],
                              "top6": [
                                true,
                                false,
                                'assets/images/char_top6.png'
                              ],
                            };

                            charAddr = "basic";

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                                "${priceList[addr]} coin으로 구매할까요?",
                                                style: const TextStyle(
                                                    color: Color(0xFF86A845),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Image.asset(
                                            'assets/images/$addr.jpg',
                                            width: width * 0.4,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background),
                                                      minimumSize:
                                                          MaterialStateProperty
                                                              .all(const Size(
                                                                  90, 50)),
                                                    ),
                                                    child: const Text(
                                                      "취소",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      if (money -
                                                              priceList[addr] <
                                                          0) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              "잔액이 부족합니다."),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  1000),
                                                        ));
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else {
                                                        // own update
                                                        collectionReference
                                                            .doc(userId)
                                                            .collection(
                                                                'closet')
                                                            .doc(addr)
                                                            .update(
                                                                {"own": true});
                                                        // money update
                                                        collectionReference
                                                            .doc(userId)
                                                            .update({
                                                          "money": money -
                                                              priceList[addr]
                                                        });
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              "구매가 완료되었습니다."),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  1000),
                                                        ));
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Theme.of(context)
                                                                  .appBarTheme
                                                                  .backgroundColor),
                                                      minimumSize:
                                                          MaterialStateProperty
                                                              .all(const Size(
                                                                  90, 50)),
                                                    ),
                                                    child: const Text("구매",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white))),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  });
                                });
                          } else {
                            setState(() {
                              tops[addr][1] = true;
                              tops[addr][0] = false;
                              charAddr = addr;

                              var nonCkLst = [];
                              for (var i = 1; i < 7; i++) {
                                if (i != int.parse(addr[3])) {
                                  nonCkLst.add(i);
                                }
                              }

                              for (var j in nonCkLst) {
                                tops['top$j'][0] = true;
                                tops['top$j'][1] = false;
                              }
                            });
                          }
                        }

                        makeTopContainer(height, addr) {
                          return GestureDetector(
                            onTap: () {
                              onTapContainer(tops, addr);
                            },
                            child: Stack(
                              children: [
                                // 샀지만 선택되어 있지 않음
                                Visibility(
                                  // visible: false,
                                  visible: tops[addr][0],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                        width: height * 0.14,
                                        height: height * 0.14,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                // 옷 이미지
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/images/$addr.jpg",
                                      width: height * 0.14,
                                      height: height * 0.14,
                                    ),
                                  ),
                                ),
                                // 샀고 클릭되어 있음
                                Visibility(
                                  visible: tops[addr][1],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      width: height * 0.14,
                                      height: height * 0.14,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                                255, 221, 227, 238)
                                            .withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                          BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 221, 227, 238)
                                                  .withOpacity(0.3),
                                              spreadRadius: -1.0,
                                              blurRadius: 2.0,
                                              offset: const Offset(0, 3)),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.check_circle_outline,
                                        size: 30,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                ),
                                // 원래 캐릭터 옷
                                Visibility(
                                  visible: addr == prev ? true : false,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                        width: height * 0.14,
                                        height: height * 0.14,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFF86A845),
                                              width: 4),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                ),
                                // 아직 안 삼
                                Visibility(
                                  visible: !ownList[addr],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      width: height * 0.14,
                                      height: height * 0.14,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(0.8),
                                      ),
                                      child: const Icon(Icons.lock, size: 30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        makeStackImage(addr) {
                          return Visibility(
                            visible: ownList['$addr'] == true
                                ? tops[addr][1]
                                : false,
                            child: Image.asset("assets/images/char_$addr.png",
                                height: height * 0.4),
                          );
                        }

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: SizedBox(
                                      width: width * 0.4,
                                      height: height * 0.4,
                                      child: Stack(
                                        children: [
                                          Visibility(
                                            visible:
                                                isFirst == true ? true : false,
                                            child: Image.asset(
                                              "assets/images/char_$prev.png",
                                              height: height * 0.4,
                                            ),
                                          ),
                                          makeStackImage('top1'),
                                          makeStackImage('top2'),
                                          makeStackImage('top3'),
                                          makeStackImage('top4'),
                                          makeStackImage('top5'),
                                          makeStackImage('top6'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        width: money.toString().length * 7 + 40,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                              ),
                                              BoxShadow(
                                                  color: Colors.white,
                                                  spreadRadius: -1.0,
                                                  blurRadius: 2.0,
                                                  offset: Offset(0, 3)),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/coin.png',
                                                width: 20,
                                              ),
                                              Text(
                                                "$money",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.012),
                              Container(
                                height: height * 0.17,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 236, 223, 184)),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      makeTopContainer(height, 'top1'),
                                      makeTopContainer(height, 'top2'),
                                      makeTopContainer(height, 'top3'),
                                      makeTopContainer(height, 'top4'),
                                      makeTopContainer(height, 'top5'),
                                      makeTopContainer(height, 'top6'),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.024),
                              Container(
                                height: height * 0.17,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 236, 223, 184)),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      makePantsContainer(height),
                                      makePantsContainer(height),
                                      makePantsContainer(height),
                                      makePantsContainer(height),
                                      makePantsContainer(height),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.024),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isFirst = false;
                                          charAddr = "basic";
                                          tops = {
                                            "top1": [
                                              true,
                                              false,
                                              'assets/images/char_top1.png'
                                            ],
                                            "top2": [
                                              true,
                                              false,
                                              'assets/images/char_top2.png'
                                            ],
                                            "top3": [
                                              true,
                                              false,
                                              'assets/images/char_top3.png'
                                            ],
                                            "top4": [
                                              true,
                                              false,
                                              'assets/images/char_top4.png'
                                            ],
                                            "top5": [
                                              true,
                                              false,
                                              'assets/images/char_top5.png'
                                            ],
                                            "top6": [
                                              true,
                                              false,
                                              'assets/images/char_top6.png'
                                            ],
                                          };
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .background),
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(90, 40)),
                                      ),
                                      child: const Text(
                                        "초기화",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (charAddr != prev) {
                                              if (prev == "basic") {
                                                collectionReference
                                                    .doc(userId)
                                                    .collection("closet")
                                                    .doc(charAddr)
                                                    .update(
                                                        {"isChecked": true});
                                              } else if (charAddr == "basic") {
                                                collectionReference
                                                    .doc(userId)
                                                    .collection("closet")
                                                    .doc(prev)
                                                    .update(
                                                        {"isChecked": false});
                                              } else {
                                                collectionReference
                                                    .doc(userId)
                                                    .collection("closet")
                                                    .doc(prev)
                                                    .update(
                                                        {"isChecked": false});
                                                collectionReference
                                                    .doc(userId)
                                                    .collection("closet")
                                                    .doc(charAddr)
                                                    .update(
                                                        {"isChecked": true});
                                              }
                                              collectionReference
                                                  .doc(userId)
                                                  .update(
                                                      {"character": charAddr});
                                            }

                                            tops = {
                                              "top1": [
                                                true,
                                                false,
                                                'assets/images/char_top1.png'
                                              ],
                                              "top2": [
                                                true,
                                                false,
                                                'assets/images/char_top2.png'
                                              ],
                                              "top3": [
                                                true,
                                                false,
                                                'assets/images/char_top3.png'
                                              ],
                                              "top4": [
                                                true,
                                                false,
                                                'assets/images/char_top4.png'
                                              ],
                                              "top5": [
                                                true,
                                                false,
                                                'assets/images/char_top5.png'
                                              ],
                                              "top6": [
                                                true,
                                                false,
                                                'assets/images/char_top6.png'
                                              ],
                                            };

                                            charAddr = "basic";
                                            isFirst = true;
                                          });

                                          Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Theme.of(context)
                                                      .appBarTheme
                                                      .backgroundColor),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(90, 40)),
                                        ),
                                        child: const Text(
                                          "저장",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
