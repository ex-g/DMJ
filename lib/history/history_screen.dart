import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _ThirdSectionState();
}

class _ThirdSectionState extends State<HistoryScreen>
// TickerProviderStateMixin >> 캘린더 위젯 사용 시 필요
    with
        TickerProviderStateMixin {
  // 파이어베이스 콜렉션 참조
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");
  // 변수 선언
  var dateFormatter = DateFormat('yyMMdd');
  var now = DateTime.now();
  Map<DateTime, List<Event>> events = {};
  CalendarFormat calFormat = CalendarFormat.month;
  DateTime selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "HISTORY",
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                String attendStr = "";
                if (!snapshot.hasData) {
                  attendStr = "로그인 후 출석 현황을 확인하세요!";
                } else {
                  var userId = snapshot.data!.uid;
                  return StreamBuilder(
                    stream: collectionReference
                        .doc(userId)
                        .collection("dayStamp")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                      } else {
                        var docs = snapshot.data!.docs;

                        if (docs.isNotEmpty && docs.length != 1) {
                          for (var doc in docs) {
                            if (doc.data()['date'] == "start") {
                            } else {
                              events[DateTime.utc(
                                  doc['year'], doc['month'], doc['day'])] = [
                                Event('출석')
                              ];
                            }
                          }
                          docs.last.data()['date'] == dateFormatter.format(now)
                              ? attendStr = "출석 도장이 지급되었습니다!"
                              : attendStr = "오늘의 학습을 시작해보세요!";
                        } else {
                          attendStr = "오늘의 학습을 시작해보세요!";
                        }
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_box,
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                  size: 17,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  attendStr,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Theme.of(context)
                                          .appBarTheme
                                          .backgroundColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                          Container(height: 10),
                          Text(
                            "Calendar",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: TableCalendar(
                              locale: 'ko-KR',
                              daysOfWeekHeight: 30,
                              calendarBuilders: CalendarBuilders(
                                dowBuilder: (context, day) {
                                  switch (day.weekday) {
                                    case 7:
                                      return const Center(
                                        child: Text(
                                          '일',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      );
                                  }
                                  return null;
                                },
                              ),
                              firstDay: DateTime.utc(2020, 01, 01),
                              lastDay: DateTime.now(),
                              focusedDay: focusedDay,
                              // 선택된 날짜의 상태를 갱신함.
                              onDaySelected:
                                  (DateTime selectedDay, DateTime focusedDay) {
                                setState(() {
                                  this.selectedDay = selectedDay;
                                  this.focusedDay = focusedDay;
                                });
                              },
                              // 선택된 날짜의 모양을 바꿈.
                              selectedDayPredicate: (DateTime day) {
                                return isSameDay(selectedDay, day);
                              },
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                              ),
                              onFormatChanged: (format) {
                                setState(
                                  () {
                                    calFormat = format;
                                  },
                                );
                              },
                              calendarStyle: const CalendarStyle(
                                markerSize: 15.0,
                                markerDecoration: BoxDecoration(
                                    color: Colors.amber,
                                    shape: BoxShape.circle),
                              ),
                              eventLoader: (DateTime day) {
                                return events[day] ?? [];
                              },
                            ),
                          )
                        ],
                      );
                    },
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_box,
                            color:
                                Theme.of(context).appBarTheme.backgroundColor,
                            size: 17,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            attendStr,
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                    Container(height: 10),
                    Text(
                      "Calendar",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        color: Theme.of(context).appBarTheme.backgroundColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: TableCalendar(
                        locale: 'ko-KR',
                        daysOfWeekHeight: 30,
                        calendarBuilders: CalendarBuilders(
                          dowBuilder: (context, day) {
                            switch (day.weekday) {
                              case 7:
                                return const Center(
                                  child: Text(
                                    '일',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                            }
                            return null;
                          },
                        ),
                        firstDay: DateTime.utc(2020, 01, 01),
                        lastDay: DateTime.now(),
                        focusedDay: focusedDay,
                        // 선택된 날짜의 상태를 갱신함.
                        onDaySelected:
                            (DateTime selectedDay, DateTime focusedDay) {
                          setState(() {
                            this.selectedDay = selectedDay;
                            this.focusedDay = focusedDay;
                          });
                        },
                        // 선택된 날짜의 모양을 바꿈.
                        selectedDayPredicate: (DateTime day) {
                          return isSameDay(selectedDay, day);
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        onFormatChanged: (format) {
                          setState(
                            () {
                              calFormat = format;
                            },
                          );
                        },
                        calendarStyle: const CalendarStyle(
                          markerSize: 15.0,
                          markerDecoration: BoxDecoration(
                              color: Colors.amber, shape: BoxShape.circle),
                        ),
                        eventLoader: (DateTime day) {
                          return events[day] ?? [];
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 이벤트 로더에 쓰일 임의의 클래스
class Event {
  String title;
  Event(this.title);
}
