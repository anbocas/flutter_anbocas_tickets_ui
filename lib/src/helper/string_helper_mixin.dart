import 'dart:math';

import 'package:anbocas_tickets_ui/src/model/company_overview_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

mixin StringHelperMixin {
  String changePrice(String price) {
    String returnPrice = price;
    if (price != '') {
      double parseString = double.parse(price);
      var f = NumberFormat('###0.00', 'en_Us');
      returnPrice = f.format(parseString);
    } else {
      returnPrice = '0.00';
    }
    return returnPrice;
  }

  double calculateInterval(double maxYValue) {
    if (maxYValue <= 0.0) {
      return 10;
    } else if (maxYValue == 1) {
      return 10;
    } else if (maxYValue == 2) {
      return 5;
    } else if (maxYValue <= 5) {
      return 2;
    } else if (maxYValue <= 10) {
      return 2;
    } else {
      // Base interval logic: (maxYValue / 10).ceilToDouble() * 2
      double baseInterval = (maxYValue / 10).ceilToDouble() * 2;

      // Determine magnitude (nearest 10, 100, 1000, etc.)
      int magnitude = (baseInterval).toStringAsFixed(0).length - 1;
      double nearestBase = pow(10, magnitude).toDouble();

      return (baseInterval / nearestBase).ceil() * nearestBase;
    }
  }

  String formatLeftValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M'; // 1M, 1.2M
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K'; // 1K, 1.5K
    } else {
      return value.toInt().toString(); // Values less than 1000 as is
    }
  }

  double calculateMaxY(List<ChartData2> datasets) {
    double maxYValue = datasets
        .expand((dataset) => dataset.data)
        .reduce((a, b) => a > b ? a : b);

    return maxYValue;
  }

  double calculateMaxY2(
      List<int> ticketsSoldList, List<double> salesVolumeList) {
    List<double> combinedList = [
      ...ticketsSoldList.map((e) => e.toDouble()),
      ...salesVolumeList
    ];
    double maxYValue = combinedList.reduce((a, b) => a > b ? a : b);
    return maxYValue;
  }

  Color generateRandomColor(Color color, int index, int totalGenerateLength) {
    final double shadeFactor = (index + 1) / totalGenerateLength;
    final Color randomShadeColor = Color.lerp(
      color.withOpacity(0.5), // Lighter shade
      color, // Darker shade
      shadeFactor,
    )!;
    return randomShadeColor;
  }
}
