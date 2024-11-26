import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/string_helper_mixin.dart';
import 'package:anbocas_tickets_ui/src/model/company_overview_response.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TimeSeriesChartTwoWidget extends StatefulWidget {
  final List<String> bottomKeys;
  final List<ChartData2> data;

  const TimeSeriesChartTwoWidget(
      {super.key, required this.bottomKeys, required this.data});

  @override
  State<TimeSeriesChartTwoWidget> createState() =>
      _TimeSeriesChartTwoWidgetState();
}

class _TimeSeriesChartTwoWidgetState extends State<TimeSeriesChartTwoWidget>
    with StringHelperMixin {
  List<Map<String, dynamic>> tileData = [];

  @override
  void didChangeDependencies() {
    tileData.clear();
    widget.data.asMap().forEach((value, data) {
      tileData.add(
          {"title": data.name, 'color': lineColors[value % lineColors.length]});
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LineChart(
          _buildLineChartData(widget.data),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: Column(
              children: [
                ...tileData.map((e) => Row(
                      children: [
                        Container(
                          height: 6,
                          width: 6,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: e['color'], shape: BoxShape.circle),
                        ),
                        Text(
                          e['title'],
                          style:
                              theme.labelStyle?.copyWith(color: Colors.black),
                        )
                      ],
                    ))
              ],
            ))
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      angle: -1,
      child: Text(widget.bottomKeys[value.toInt()],
          style: theme.labelStyle?.copyWith(
            color: Colors.black,
          )),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 30,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String title = formatLeftValue(value);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 2,
      child: Text(title,
          style: theme.labelStyle?.copyWith(
              color: Colors.black,
              fontSize: 7.adaptSize,
              fontWeight: FontWeight.w600)),
    );
  }

  SideTitles leftTitles(double interval) => SideTitles(
        showTitles: true,
        interval: interval,
        getTitlesWidget: leftTitleWidgets,
      );

  LineChartData _buildLineChartData(List<ChartData2> data) {
    double maxYValue = calculateMaxY(data);
    double intervalY = calculateInterval(maxYValue);

    return LineChartData(
      gridData:
          const FlGridData(drawHorizontalLine: true, drawVerticalLine: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(intervalY),
        ),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(bottom: BorderSide(color: Colors.grey)),
      ),
      minX: 0,
      maxX: widget.bottomKeys.length - 1,
      minY: 0,
      maxY: ((maxYValue + intervalY) / 100).ceil() * 100,
      lineBarsData: data
          .map((entry) => _buildChartLine(entry, data.indexOf(entry)))
          .toList(),
    );
  }

  LineChartBarData _buildChartLine(ChartData2 data, int index) {
    return LineChartBarData(
      // isCurved: true,
      color: tileData[index]['color'],
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: data.data
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
          .toList(),
    );
  }

  final List<Color> lineColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];
}
