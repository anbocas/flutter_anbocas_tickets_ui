// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/components/time_series_chart_two_widget.dart';
import 'package:flutter/material.dart';
import 'package:anbocas_tickets_ui/src/model/company_overview_response.dart';

class ChartYearlyContainerWidget extends StatefulWidget {
  final CompanyCharts charts;
  const ChartYearlyContainerWidget({
    Key? key,
    required this.charts,
  }) : super(key: key);

  @override
  State<ChartYearlyContainerWidget> createState() =>
      _ChartYearlyContainerWidgetState();
}

class _ChartYearlyContainerWidgetState
    extends State<ChartYearlyContainerWidget> {
  ValueNotifier<ChartData?> selectedYear = ValueNotifier(null);

  @override
  void initState() {
    if (widget.charts.timeSeriesData.isNotEmpty) {
      selectedYear.value = widget.charts.timeSeriesData[0];
    }
    super.initState();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.charts.title ?? "",
                  style: theme.bodyStyle,
                ),
              ),
              SizedBox(
                width: 5.h,
              ),
              Container(
                height: 40.v,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                child: DropdownButton<ChartData>(
                  value: selectedYear.value,
                  dropdownColor: theme.secondaryTextColor,
                  onChanged: (value) {
                    selectedYear.value = value!;
                  },
                  underline: const SizedBox(),
                  items: widget.charts.timeSeriesData.map((chartData) {
                    return DropdownMenuItem<ChartData>(
                      value: chartData,
                      child: Text(
                        chartData.year.toString(),
                        style: theme.hintStyle
                            ?.copyWith(color: theme.backgroundColor),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ValueListenableBuilder<ChartData?>(
            valueListenable: selectedYear,
            builder: (context, value, child) {
              return value == null
                  ? const SizedBox.shrink()
                  : SizedBox(
                      height: 250.v,
                      child: TimeSeriesChartTwoWidget(
                        bottomKeys: widget.charts.keys,
                        data: value.data ?? [],
                      ));
            },
          )
        ],
      ),
    );
  }
}
