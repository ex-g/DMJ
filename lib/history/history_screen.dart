import 'package:dmj/history/static_card.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _ThirdSectionState();
}

class _ThirdSectionState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  CalendarFormat calFormat = CalendarFormat.month;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
    super.initState();
  }

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
          children: [
            const SizedBox(height: 20),
            Container(
              clipBehavior: Clip.none,
              child: Transform.translate(
                offset: const Offset(-80, 0),
                child: Text(
                  "Calendar",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    color: Theme.of(context).appBarTheme.backgroundColor,
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
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                    }
                    return null;
                  },
                ),
                firstDay: DateTime.utc(2020, 01, 01),
                lastDay: DateTime.now(),
                focusedDay: DateTime.now(),
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
              ),
            ),
            Container(
              decoration: const BoxDecoration(),
              clipBehavior: Clip.none,
              child: Transform.translate(
                offset: const Offset(-100, -20),
                child: Text(
                  "Statics",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    color: Theme.of(context).appBarTheme.backgroundColor,
                  ),
                ),
              ),
            ),
            Container(
              width: 320,
              decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(25)),
              child: TabBar(
                tabs: [
                  Container(
                    height: 30,
                    alignment: Alignment.center,
                    child: const Text(
                      'Day',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: const Text(
                        'Week',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Container(
                    height: 30,
                    alignment: Alignment.center,
                    child: const Text(
                      'Month',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    alignment: Alignment.center,
                    child: const Text(
                      'Year',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                labelColor: Theme.of(context).cardColor,
                unselectedLabelColor: Theme.of(context).colorScheme.background,
                controller: _tabController,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  StaticCard(wordCount: "3개", time: "10분"),
                  StaticCard(wordCount: "24개", time: "80분"),
                  StaticCard(wordCount: "45개", time: "200분"),
                  StaticCard(wordCount: "300개", time: "950분"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
