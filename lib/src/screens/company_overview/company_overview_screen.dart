import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/snackbar_mixin.dart';
import 'package:anbocas_tickets_ui/src/model/api_response.dart';
import 'package:anbocas_tickets_ui/src/model/company_overview_response.dart';
import 'package:anbocas_tickets_ui/src/components/chart_container_widget.dart';
import 'package:anbocas_tickets_ui/src/components/pie_series_chart_widget.dart';
import 'package:anbocas_tickets_ui/src/components/time_series_chart_widget.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_booking_manager.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_company_overview.dart';
import 'package:flutter/material.dart';

class CompanyOverviewWidget extends StatefulWidget {
  final String companyId;
  const CompanyOverviewWidget({super.key, required this.companyId});

  @override
  State<CompanyOverviewWidget> createState() => _CompanyOverviewWidgetState();

  static CompanyOverviewWidgetState? of(BuildContext context) =>
      context.findAncestorStateOfType<CompanyOverviewWidgetState>();
}

class _CompanyOverviewWidgetState extends CompanyOverviewWidgetState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        title: Text("Dashboard", style: theme.headingStyle),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: _iconBack(theme.iconColor!),
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Builder(builder: (context) {
          final state = CompanyOverviewWidget.of(context)!;
          return ValueListenableBuilder<bool>(
              valueListenable: state.isLoading,
              builder: (context, isLoading, child) {
                return isLoading
                    ? _buildLoader()
                    : state.overviewResponse.value == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.h),
                            child: ListView(
                              children: [
                                GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                    childAspectRatio: 3 / 2,
                                  ),
                                  itemCount: state.overviewResponse.value
                                      ?.statistics.length,
                                  itemBuilder: (context, index) {
                                    final item = state.overviewResponse.value
                                        ?.statistics[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: theme.secondaryBgColor,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            item?.title ?? '',
                                            style: theme.bodyStyle,
                                          ),
                                          const SizedBox(height: 10.0),
                                          Text(
                                            '${item?.total ?? 0}',
                                            style: theme.headingStyle,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                ...state.overviewResponse.value!
                                    .normalCompCharts()
                                    .map((e) => Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 20.v),
                                        padding: EdgeInsets.all(10.h),
                                        decoration: BoxDecoration(
                                            color: theme.secondaryBgColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(children: [
                                          Text(
                                            e.title ?? "",
                                            textAlign: TextAlign.center,
                                            style: theme.bodyStyle,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            height: 280.v,
                                            child: TimeSeriesChartWidget(
                                              bottomKeys: e.keys,
                                              data: e.timeSeriesData,
                                            ),
                                          )
                                        ]))),
                                ...state.overviewResponse.value!
                                    .yearlyCharts()
                                    .map((e) => ChartYearlyContainerWidget(
                                          charts: e,
                                        )),
                                ...state.overviewResponse.value!
                                    .pieCharts()
                                    .map((e) => PieSeriesChartWidget(
                                          title: e.title ?? "",
                                          keys: e.keys,
                                          pieChartData: e.pieChartData,
                                        )),
                              ],
                            ),
                          );
              });
        }),
      ),
    );
  }

  Icon _iconBack(Color color) => Icon(
        Icons.arrow_back,
        color: color,
      );

  Widget _buildLoader() {
    return Center(
        child: CircularProgressIndicator(
      strokeWidth: 4.adaptSize,
      color: theme.accentColor,
      backgroundColor: Colors.white,
    ));
  }
}

abstract class CompanyOverviewWidgetState extends State<CompanyOverviewWidget>
    with SnackbarMixin {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<CompanyOverviewResponse?> overviewResponse =
      ValueNotifier(null);
  final AnbocasCompanyOverviewRepo? _overview =
      AnbocasServiceManager().overviewRepo;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOverview();
    });
    super.initState();
  }

  @override
  void dispose() {
    isLoading.dispose();
    overviewResponse.dispose();

    super.dispose();
  }

  Future<void> _fetchOverview() async {
    isLoading.value = true;
    ApiResponse<CompanyOverviewResponse>? response =
        await _overview?.getCompanyOverview(companyId: widget.companyId);
    isLoading.value = false;
    if (response != null) {
      if (response.data != null) {
        overviewResponse.value = response.data!;
      }
      if (response.error != null) {
        if (!mounted) return;
        showAlertSnackBar(context, response.error ?? "Something went wrong");
      }
    }
  }
}
