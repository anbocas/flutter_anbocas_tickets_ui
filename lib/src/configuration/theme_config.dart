import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:flutter/material.dart';

class AnbocasCustomTheme {
  AnbocasCustomTheme({
    this.backgroundColor = Colors.black,
    this.secondaryBgColor = const Color.fromARGB(66, 137, 130, 130),
    this.primaryTextColor = Colors.white,
    this.secondaryTextColor = Colors.grey,
    this.iconColor = Colors.white,
    this.secondaryIconColor = Colors.red,
    this.accentColor = Colors.orange,
    this.dividerColor = Colors.grey,
    this.errorColor = Colors.red,
    this.headingStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 22,
    ),
    this.subHeadingStyle = const TextStyle(
      color: Colors.orange,
      fontWeight: FontWeight.w700,
      fontSize: 18,
    ),
    this.bodyStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    this.labelStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    this.hintStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    this.smallLabelStyle = const TextStyle(
      fontSize: 12,
      height: 1.2,
      color: Colors.grey,
    ),
    ButtonStyle? buttonStyle,
    this.themeData,
    this.textFormFieldConfig = const AnbocasTextFormFieldConfig(),
  }) : buttonStyle = buttonStyle ?? _defaultButtonStyle;

  Color? backgroundColor;
  Color? secondaryBgColor;
  Color? primaryTextColor;
  Color? secondaryTextColor;
  Color? iconColor;
  Color? secondaryIconColor;
  Color? accentColor;
  Color? dividerColor;
  Color? errorColor;
  TextStyle? headingStyle;
  TextStyle? subHeadingStyle;
  TextStyle? bodyStyle;
  TextStyle? labelStyle;
  TextStyle? hintStyle;
  TextStyle? smallLabelStyle;
  ButtonStyle? buttonStyle;
  ThemeData? themeData;
  AnbocasTextFormFieldConfig textFormFieldConfig;

  static final ButtonStyle _defaultButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    minimumSize: WidgetStateProperty.all<Size>(
      const Size(double.infinity, 50),
    ),
  );

  void updateConfig(AnbocasCustomTheme? newConfig) {
    backgroundColor = newConfig?.backgroundColor ?? Colors.black;
    secondaryBgColor =
        newConfig?.secondaryBgColor ?? const Color.fromARGB(66, 137, 130, 130);
    primaryTextColor = newConfig?.primaryTextColor ?? Colors.white;
    secondaryTextColor = newConfig?.secondaryTextColor ?? Colors.grey;
    iconColor = newConfig?.iconColor ?? Colors.white;
    secondaryIconColor = newConfig?.secondaryIconColor ?? Colors.red;
    accentColor = newConfig?.accentColor ?? Colors.orange;
    dividerColor = newConfig?.dividerColor ?? Colors.grey;
    errorColor = newConfig?.errorColor ?? Colors.red;
    headingStyle = newConfig?.headingStyle ??
        const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        );
    subHeadingStyle = newConfig?.subHeadingStyle ??
        const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        );
    bodyStyle = newConfig?.bodyStyle ??
        const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        );
    labelStyle = newConfig?.labelStyle ??
        const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );
    smallLabelStyle = newConfig?.smallLabelStyle ??
        const TextStyle(
          fontSize: 12,
          height: 1.2,
          color: Colors.grey,
        );
    buttonStyle = newConfig?.buttonStyle ?? _defaultButtonStyle;
    themeData = newConfig?.themeData ?? toThemeData();
  }

  ThemeData toThemeData() {
    return (themeData ?? ThemeData()).copyWith(
      scaffoldBackgroundColor: backgroundColor,
      outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
      elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
      textTheme: TextTheme(
        headlineMedium: headingStyle,
        headlineSmall: subHeadingStyle,
        bodyMedium: bodyStyle,
        labelMedium: labelStyle,
        labelSmall: smallLabelStyle,
      ),
    );
  }
}

class AnbocasTextFormFieldConfig {
  const AnbocasTextFormFieldConfig({
    this.cursorColor = Colors.black,
    this.fillColor = Colors.transparent,
    this.labelStyle = const TextStyle(color: Colors.black, fontSize: 12),
    this.hintStyle = const TextStyle(color: Colors.grey, fontSize: 14),
    this.style = const TextStyle(color: Colors.black, fontSize: 14),
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    this.border = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.0),
    ),
    this.errorBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    this.focusedBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.0),
    ),
    this.inputBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.0),
    ),
    this.enabledBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.0),
    ),
  });

  final Color? cursorColor;
  final Color? fillColor;
  final TextStyle labelStyle;
  final TextStyle hintStyle;
  final TextStyle style;
  final EdgeInsetsGeometry contentPadding;
  final InputBorder border;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? inputBorder;
  final InputBorder? enabledBorder;
}
