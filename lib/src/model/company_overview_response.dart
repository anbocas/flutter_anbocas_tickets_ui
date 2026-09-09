class CompanyOverviewResponse {
  List<CompanyOnboarding> onboarding = [];
  List<CompanyStatistics> statistics = [];
  List<CompanyCharts> charts = [];

  List<CompanyCharts> yearlyCharts() {
    return charts
        .where((value) => (value.type == CompanyChartsEnum.timeSeries.name &&
            value.yearlyData == true))
        .toList();
  }

  List<CompanyCharts> normalCompCharts() {
    return charts
        .where((value) => (value.type == CompanyChartsEnum.timeSeries.name &&
            value.yearlyData == false))
        .toList();
  }

  List<CompanyCharts> pieCharts() {
    return charts
        .where((value) => (value.type == CompanyChartsEnum.pieChart.name))
        .toList();
  }

  CompanyOverviewResponse(
      {required this.onboarding,
      required this.statistics,
      required this.charts});

  CompanyOverviewResponse.fromJson(Map<String, dynamic> json) {
    if (json["onboarding"] is List) {
      onboarding = (json["onboarding"] as List)
          .map((e) => CompanyOnboarding.fromJson(e))
          .toList();
    }
    if (json["statistics"] is List) {
      statistics = (json["statistics"] as List)
          .map((e) => CompanyStatistics.fromJson(e))
          .toList();
    }
    if (json["charts"] is List) {
      charts = (json["charts"] as List)
          .map((e) => CompanyCharts.fromJson(e))
          .toList();
    }
  }

  static List<CompanyOverviewResponse> fromList(
      List<Map<String, dynamic>> list) {
    return list.map(CompanyOverviewResponse.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["onboarding"] = onboarding.map((e) => e.toJson()).toList();
    data["statistics"] = statistics.map((e) => e.toJson()).toList();
    data["charts"] = charts.map((e) => e.toJson()).toList();
    return data;
  }
}

class CompanyCharts {
  String? type;
  String? title;
  List<String> keys = [];
  List<ChartData> timeSeriesData = [];
  List<double> pieChartData = [];
  bool yearlyData = false;

  CompanyCharts.fromJson(Map<String, dynamic> json) {
    if (json["type"] is String) {
      type = json["type"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["keys"] is List) {
      keys = List<String>.from(json["keys"]);
    }
    if (json["data"] is List) {
      if (type == CompanyChartsEnum.timeSeries.name) {
        timeSeriesData =
            (json["data"] as List).map((e) => ChartData.fromJson(e)).toList();
      }

      if (type == CompanyChartsEnum.pieChart.name) {
        pieChartData = (json["data"] as List).map((item) {
          if (item is String) {
            return double.tryParse(item) ?? 0.0;
          } else if (item is int) {
            return item.toDouble();
          } else if (item is double) {
            return item;
          }
          return 0.0;
        }).toList();
      }
    }
    if (json["yearly_data"] is bool) {
      yearlyData = json["yearly_data"];
    }
  }

  static List<CompanyCharts> fromList(List<Map<String, dynamic>> list) {
    return list.map(CompanyCharts.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["type"] = type;
    data["title"] = title;
    data["keys"] = keys;
    data["data"] = timeSeriesData.map((e) => e.toJson()).toList();
    data["yearly_data"] = yearlyData;
    return data;
  }
}

class ChartData {
  int? year;
  List<ChartData2>? data;
  String? date;
  int ticketsSold = 0;
  double salesVolume = 0.0;

  ChartData({this.date, required this.ticketsSold, required this.salesVolume});

  ChartData.fromJson(Map<String, dynamic> json) {
    if (json["year"] is int) {
      year = json["year"];
    }
    if (json["date"] is String) {
      date = json["date"];
    }
    if (json["tickets_sold"] is int) {
      ticketsSold = json["tickets_sold"];
    }
    if (json["sales_volume"] != null) {
      if (json["sales_volume"] is int) {
        salesVolume = (json["sales_volume"] as int).toDouble();
      } else if (json["sales_volume"] is String) {
        salesVolume = double.tryParse(json["sales_volume"]) ?? 0.0;
      } else if (json["sales_volume"] is double) {
        salesVolume = json["sales_volume"];
      }
    }
    if (json["data"] is List) {
      data = json["data"] == null
          ? null
          : (json["data"] as List).map((e) => ChartData2.fromJson(e)).toList();
    }
  }

  static List<ChartData> fromList(List<Map<String, dynamic>> list) {
    return list.map(ChartData.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap["year"] = year;
    jsonMap["date"] = date;
    jsonMap["tickets_sold"] = ticketsSold;
    jsonMap["sales_volume"] = salesVolume;
    jsonMap["data"] = data?.map((e) => e.toJson()).toList();
    return jsonMap;
  }
}

class CompanyStatistics {
  String? title;
  num? total;

  CompanyStatistics({this.title, this.total});

  CompanyStatistics.fromJson(Map<String, dynamic> json) {
    if (json["title"] is String) {
      title = json["title"];
    }

    if (json["total"] != null) {
      if (json["total"] is int) {
        total = json["total"];
      } else if (json["total"] is String) {
        total = double.tryParse(json["total"]) ?? 0.0;
      } else if (json["total"] is double) {
        total = json["total"];
      }
    }
  }

  static List<CompanyStatistics> fromList(List<Map<String, dynamic>> list) {
    return list.map(CompanyStatistics.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["total"] = total;
    return data;
  }
}

class CompanyOnboarding {
  String? key;
  bool? value;

  CompanyOnboarding({this.key, this.value});

  CompanyOnboarding.fromJson(Map<String, dynamic> json) {
    if (json["key"] is String) {
      key = json["key"];
    }
    if (json["value"] is bool) {
      value = json["value"];
    }
  }

  static List<CompanyOnboarding> fromList(List<Map<String, dynamic>> list) {
    return list.map(CompanyOnboarding.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["key"] = key;
    data["value"] = value;
    return data;
  }
}

enum CompanyChartsEnum {
  timeSeries("time-series"),
  pieChart("pie-chart");

  const CompanyChartsEnum(this.name);
  final String name;
}

class ChartData2 {
  String? name;
  List<double> data = [];

  ChartData2.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["data"] is List) {
      data = (json["data"] as List).map((item) {
        if (item is double) {
          return item;
        } else if (item is int) {
          return item.toDouble();
        } else if (item is String) {
          return double.tryParse(item) ?? 0.0;
        }
        return 0.0;
      }).toList();
    }
  }

  static List<ChartData2> fromList(List<Map<String, dynamic>> list) {
    return list.map(ChartData2.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap["name"] = name;
    jsonMap["data"] = data;
    return jsonMap;
  }
}
