import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banking_app/json/transactions.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/layouts.dart';
import 'package:flutter_banking_app/widgets/my_app_bar.dart';
import 'package:gap/gap.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(
          title: 'Stats',
          implyLeading: false,
          context: context,
          hasAction: true),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Repository.accentColor2(context),
              border: Border.all(color: Repository.accentColor(context))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                    child: Text('Total Balance',
                        style:
                            TextStyle(color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
                    child: Text('\$20,000.00 USD',
                        style: TextStyle(
                            color: Repository.titleColor(context),
                            fontSize: 32,
                            fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Gap(20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Repository.accentColor2(context),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Repository.accentColor(context))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  width: size.width*0.44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Repository.headerColor(context)),
                  child: const Text('Income', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  width: size.width * 0.44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.transparent),
                  child: Text('Expenses',
                      style: TextStyle(
                          color: Repository.titleColor(context), fontSize: 17, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          const Gap(20),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(color: Repository.accentColor(context))
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Repository.iconColor(context),
                            child: const Icon(Icons.show_chart_rounded,
                                color: Colors.orange),
                          ),
                          const Gap(6),
                          CircleAvatar(
                            backgroundColor: Repository.iconColor(context),
                            child: Icon(CupertinoIcons.eye_slash_fill,
                                color: Repository.titleColor(context), size: 17),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Repository.cardColor2(context),
                        ),
                        child: Row(
                          children: [
                            const Text('This week',
                                style: TextStyle(color: Colors.white)),
                            const Gap(8),
                            Icon(CupertinoIcons.chevron_down,
                                color: Colors.white.withOpacity(0.8), size: 17)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1.70,
                  child: LineChart(
                    mainData(),
                  ),
                ),
              ],
            ),
          ),
          const Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transactions',
                  style: TextStyle(
                      color: Repository.titleColor(context),
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text('View all',
                      style: TextStyle(
                          color: Repository.titleColor(context), fontSize: 16)),
                  const Gap(3),
                  Transform.rotate(
                      angle: math.pi,
                      child: Icon(Icons.keyboard_backspace_rounded,
                          color: Repository.titleColor(context), size: 18))
                ],
              )
            ],
          ),
          const Gap(20),
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (c, i) {
                final trs = transactions[i];
                return ListTile(
                  isThreeLine: true,
                  minLeadingWidth: 10,
                  minVerticalPadding: 20,
                  contentPadding: const EdgeInsets.all(0),
                  leading: Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Repository.accentColor(context),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 2,
                            spreadRadius: 1,
                          )
                        ],
                        image: i == 0
                            ? null
                            : DecorationImage(
                          image: AssetImage(trs['avatar']),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: i == 0
                          ? Icon(trs['icon'],
                          color: const Color(0xFFFF736C), size: 20)
                          : const SizedBox()),
                  title: Text(trs['name'],
                      style: TextStyle(color: Repository.textColor(context), fontWeight: FontWeight.w500)),
                  subtitle: Text(trs['date'],
                      style: TextStyle(color: Repository.subTextColor(context))),
                  trailing: Text(trs['amount'],
                      style: const TextStyle(fontSize: 17, color: Colors.white)),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  LineChartData mainData() {
    List<Color> gradientColors = [
      Repository.selectedItemColor(context)
    ];
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.transparent,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            //color: Repository.selectedItemColor(context),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: 1.1,
          getTitlesWidget: (value, meta) {
            const style = TextStyle(color: Colors.grey, fontSize: 17);
            switch (value.toInt()) {
              case 1:
                return const Text('S', style: style);
              case 2:
                return const Text('M', style: style);
              case 3:
                return const Text('T', style: style);
              case 4:
                return const Text('W', style: style);
              case 5:
                return const Text('T', style: style);
              case 6:
                return const Text('F', style: style);
              case 7:
                return const Text('S', style: style);
            }
            return const Text('');
          },
          // margin is not part of SideTitles in newer versions; use reservedSize instead
        )),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: Repository.selectedItemColor(context), width: 1),
      ),
      minX: 0,
      maxX: 9,
      minY: 0,
      maxY: 6,
      lineBarsData: [
          LineChartBarData(
          spots: [
            const FlSpot(0, 3),
            const FlSpot(1.5, 3),
            const FlSpot(3.5, 5),
            const FlSpot(5, 3),
            const FlSpot(6.5, 4),
            const FlSpot(8, 2.8),
            const FlSpot(9, 3),
          ],
          isCurved: true,
          color: gradientColors.first,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }
}
