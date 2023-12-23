import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/history/profile_screen.dart';
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
    with TickerProviderStateMixin {
  late TabController _tabController;
  CalendarFormat calFormat = CalendarFormat.month;
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");

  var dateFormatter = DateFormat('yyMMdd');
  var now = DateTime.now();

  @override
  void initState() {
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  // 선택된 날짜
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  // 오늘 날짜
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
              },
              icon: const Icon(Icons.person))
        ],
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
          children: [
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  var userId = snapshot.data!.uid;

                  return Column(
                    children: [
                      StreamBuilder(
                        stream: collectionReference
                            .doc(userId)
                            .collection("dayStamp")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            final docs = snapshot.data!.docs;
                            Map<DateTime, List<Event>> events = {};
                            for (var doc in docs) {
                              events[DateTime.utc(
                                  doc['year'], doc['month'], doc['day'])] = [
                                Event('출석')
                              ];
                            }

                            return Column(
                              children: [
                                docs.last.data()['date'] ==
                                        dateFormatter.format(now)
                                    ? const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.emoji_emotions,
                                              color: Colors.black54,
                                              size: 17,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "출석 도장이 지급되었습니다!",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(
                                              Icons.thumb_up,
                                              color: Colors.black54,
                                              size: 17,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  height: 10,
                                ),
                                Container(
                                  clipBehavior: Clip.none,
                                  child: Transform.translate(
                                    offset: const Offset(-80, 0),
                                    child: Text(
                                      "Calendar",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 30,
                                        color: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  height: 430,
                                  child: TableCalendar(
                                    locale: 'ko-KR',
                                    daysOfWeekHeight: 30,
                                    calendarBuilders: CalendarBuilders(
                                      dowBuilder: (context, day) {
                                        switch (day.weekday) {
                                          case 1:
                                            return const Center(
                                              child: Text('월'),
                                            );
                                          case 2:
                                            return const Center(
                                              child: Text('화'),
                                            );
                                          case 3:
                                            return const Center(
                                              child: Text('수'),
                                            );
                                          case 4:
                                            return const Center(
                                              child: Text('목'),
                                            );
                                          case 5:
                                            return const Center(
                                              child: Text('금'),
                                            );
                                          case 6:
                                            return const Center(
                                              child: Text('토'),
                                            );
                                          case 7:
                                            return const Center(
                                              child: Text(
                                                '일',
                                                style: TextStyle(
                                                    color: Colors.red),
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
                                    onDaySelected: (DateTime selectedDay,
                                        DateTime focusedDay) {
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
                          }
                        },
                      ),
                    ],
                  );
                }
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
