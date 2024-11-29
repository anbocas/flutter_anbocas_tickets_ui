import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/string_helper_mixin.dart';
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
  final String title;
  final List<String> keys;
  final List<double> pieChartData;
  const PieSeriesChartWidget({
    Key? key,
    required this.title,
    required this.keys,
    required this.pieChartData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State<PieSeriesChartWidget>
    with StringHelperMixin {
  List<PieSeriesChartData> combinedData = [];

  @override
  void didChangeDependencies() {
    combinedData.clear();
    combinedData = combiningTheTwoList();
    super.didChangeDependencies();
  }

  double totalValue = 0.0;
  List<PieSeriesChartData> combiningTheTwoList() {
    List<PieSeriesChartData> combinedList = [];
    for (int i = 0; i < widget.keys.length; i++) {
      final double value = (i < widget.pieChartData.length)
          ? widget.pieChartData[i].toDouble()
          : 0.0;
      totalValue += value;
      final Color randomShadeColor =
          generateRandomColor(theme.primaryColor!, i, widget.keys.length);
      combinedList
          .add(PieSeriesChartData(widget.keys[i], value, randomShadeColor));
    }
    return combinedList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.v),
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
          color: theme.secondaryBgColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(
            widget.title,
            style: theme.bodyStyle,
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
          Wrap(
            spacing: 5,
            children: [
              ...combinedData
                  .map(
                    (e) => Indicator(
                      color: e.color,
                      text:
                          "${e.key} - (${((e.value / totalValue) * 100).toStringAsFixed(2)}%)",
                      isSquare: false,
                    ),
                  )
                  .toList()
            ],
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
            value: (combinedData[i].value / totalValue) * 100,
            // title: combinedData[i].value.toString(),
            title: "",
            radius: (80 + i * 1.2).toDouble(),
            titlePositionPercentageOffset: 0.60,
            borderSide: BorderSide.none,
            titleStyle: theme.bodyStyle);
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
      mainAxisSize: MainAxisSize.min,
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
        Expanded(
          child: Text(
            text,
            style: theme.labelStyle,
          ),
        )
      ],
    );
  }
}
