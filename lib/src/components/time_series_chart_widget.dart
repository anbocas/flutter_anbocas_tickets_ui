import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/string_helper_mixin.dart';
import 'package:anbocas_tickets_ui/src/model/company_overview_response.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TimeSeriesChartWidget extends StatefulWidget {
  final List<String> bottomKeys;
  final List<ChartData> data;

  const TimeSeriesChartWidget(
      {super.key, required this.bottomKeys, required this.data});

  @override
  State<TimeSeriesChartWidget> createState() => _TimeSeriesChartWidgetState();
}

class _TimeSeriesChartWidgetState extends State<TimeSeriesChartWidget>
    with StringHelperMixin {
  List<Map<String, dynamic>> tileData = [];
  List<int> get ticketsSoldList =>
      widget.data.map((chart) => chart.ticketsSold).toList();
  List<double> get salesVolumeList =>
      widget.data.map((chart) => chart.salesVolume).toList();

  @override
  void didChangeDependencies() {
    tileData.clear();
    if (ticketsSoldList.isNotEmpty) {
      tileData.add({
        "title": "Ticket Sales",
        'color': generateRandomColor(theme.primaryColor!, 0, 2)
      });
    }
    if (salesVolumeList.isNotEmpty) {
      tileData.add({
        "title": "Sales Volume",
        'color': generateRandomColor(theme.primaryColor!, 1, 2)
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LineChart(
          _buildLineChartData(ticketsSoldList, salesVolumeList),
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
                          style: theme.labelStyle,
                        )
                      ],
                    ))
              ],
            ))
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String title = widget.bottomKeys[value.toInt()];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      angle: -1,
      child: Text(title,
          style: theme.labelStyle?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: title.length >= 8 ? 7.adaptSize : 12.adaptSize)),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String title = formatLeftValue(value);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 2,
      child: Text(title,
          style: theme.labelStyle
              ?.copyWith(fontSize: 7.adaptSize, fontWeight: FontWeight.w600)),
    );
  }

  SideTitles leftTitles(double interval) => SideTitles(
        showTitles: true,
        interval: interval,
        getTitlesWidget: leftTitleWidgets,
      );

  LineChartData _buildLineChartData(
      List<int> ticketsSoldList, List<double> salesVolumeList) {
    double maxYValue = calculateMaxY2(ticketsSoldList, salesVolumeList);
    double intervalY = calculateInterval(maxYValue);

    return LineChartData(
      gridData: const FlGridData(
        drawHorizontalLine: true,
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          drawBelowEverything: false,
          sideTitles: bottomTitles,
        ),
        leftTitles: AxisTitles(
          drawBelowEverything: false,
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
      lineBarsData: [
        if (ticketsSoldList.isNotEmpty) _buildChartLine(ticketsSoldList, 0),
        if (salesVolumeList.isNotEmpty) _buildChartLine(salesVolumeList, 1)
      ],
    );
  }

  LineChartBarData _buildChartLine(List<dynamic> data, int index) {
    return LineChartBarData(
      // isCurved: true,
      color: tileData[index]['color'],
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: data
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
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
