// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieSeriesChartData {
  final String key;
  final double value;
  final Color color;

  PieSeriesChartData(
    this.key,
    this.value,
    this.color,
  );
}

class PieSeriesChartWidget extends StatefulWidget {
  final List<String> keys;
  final List<double> pieChartData;
  const PieSeriesChartWidget({
    Key? key,
    required this.keys,
    required this.pieChartData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State<PieSeriesChartWidget> {
  List<PieSeriesChartData> combinedData = [];

  @override
  void didChangeDependencies() {
    combinedData.clear();
    combinedData = combiningTheTwoList();
    super.didChangeDependencies();
  }

  List<PieSeriesChartData> combiningTheTwoList() {
    List<PieSeriesChartData> combinedList = [];
    for (int i = 0;
        i < widget.keys.length && i < widget.pieChartData.length;
        i++) {
      final random = Random();
      final randomColor = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1.0,
      );
      combinedList.add(PieSeriesChartData(
          widget.keys[i], widget.pieChartData[i].toDouble(), randomColor));
    }
    return combinedList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.v),
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              ...combinedData
                  .map(
                    (e) => Indicator(
                      color: e.color,
                      text: e.key,
                      isSquare: false,
                    ),
                  )
                  .toList()
            ],
          ),
          SizedBox(
            height: 200.v,
            child: PieChart(
              PieChartData(
                startDegreeOffset: 180,
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 1,
                centerSpaceRadius: 0,
                sections: showingSections(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      combinedData.length,
      (i) {
        return PieChartSectionData(
          color: combinedData[i].color,
          value: combinedData[i].value,
          title: combinedData[i].value.toString(),
          radius: 80,
          titlePositionPercentageOffset: 0.55,
        );
      },
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: theme.labelStyle?.copyWith(color: Colors.black),
        )
      ],
    );
  }
}
