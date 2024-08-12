import 'package:flutter/material.dart';

const num FIGMA_DESIGN_WIDTH = 360;
const num FIGMA_DESIGN_HEIGHT = 800;
const num FIGMA_DESIGN_STATUS_BAR = 0;

/// This extension is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
extension ResponsiveExtension on num {
  MediaQueryData get mediaQueryData {
    if (MediaQueryHolder().mediaQueryData == null) {
      throw Exception(
          "MediaQueryHolder is not initialized. Please call MediaQueryHolder().initialize(context) first.");
    }
    return MediaQueryHolder().mediaQueryData!;
  }

  /// This method is used to get device viewport width.
  double get _width {
    return mediaQueryData.size.width;
  }

  /// This method is used to get device viewport height.
  double get _height {
    num statusBar = mediaQueryData.viewPadding.top;
    num bottomBar = mediaQueryData.viewPadding.bottom;
    num screenHeight = mediaQueryData.size.height - statusBar - bottomBar;
    return screenHeight.toDouble();
  }

  /// This method is used to set padding/margin (for the left and Right side) & width of the screen or widget according to the Viewport width.
  double get h => ((this * _width) / FIGMA_DESIGN_WIDTH);

  /// This method is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
  double get v =>
      (this * _height) / (FIGMA_DESIGN_HEIGHT - FIGMA_DESIGN_STATUS_BAR);

  /// This method is used to set smallest px in image height and width
  double get adaptSize {
    var height = v;
    var width = h;
    return height < width ? height.toDoubleValue() : width.toDoubleValue();
  }

  /// This method is used to set text font size according to Viewport
  double get fSize => adaptSize;
}

extension FormatExtension on double {
  /// Return a [double] value with formatted according to provided fractionDigits
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}

class MediaQueryHolder {
  static final MediaQueryHolder _instance = MediaQueryHolder._internal();

  factory MediaQueryHolder() {
    return _instance;
  }

  MediaQueryHolder._internal();

  MediaQueryData? mediaQueryData;

  void initialize(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
  }
}
