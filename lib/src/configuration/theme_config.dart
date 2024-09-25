import 'package:flutter/material.dart';

class AnbocasCustomTheme {
  AnbocasCustomTheme({
    this.backgroundColor = const Color(0xFF151313),
    this.secondaryBgColor = const Color(0xFF2D2D2D),
    this.primaryTextColor = Colors.white,
    this.secondaryTextColor = Colors.grey,
    this.iconColor = Colors.white,
    this.secondaryIconColor = Colors.red,
    this.accentColor = Colors.orange,
    this.primaryColor = const Color(0xFFB71C1C),
    this.dividerColor = Colors.grey,
    this.errorColor = const Color(0xFFB71C1C),
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
    this.ticketCardConfig = const AnbocasTicketCardConfig(),
    this.qrcodeColor = Colors.white,
  }) : buttonStyle = buttonStyle ?? _defaultButtonStyle;

  Color? backgroundColor;
  Color? secondaryBgColor;
  Color? primaryTextColor;
  Color? secondaryTextColor;
  Color? iconColor;
  Color? secondaryIconColor;
  Color? primaryColor;
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

  Color? qrcodeColor;
  AnbocasTextFormFieldConfig textFormFieldConfig;
  AnbocasTicketCardConfig ticketCardConfig;
  ThemeData? themeData;

  static final ButtonStyle _defaultButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFFB71C1C)),
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
    backgroundColor = newConfig?.backgroundColor ?? const Color(0xFF151313);
    primaryColor = newConfig?.primaryColor ?? const Color(0xFFB71C1C);
    secondaryBgColor = newConfig?.secondaryBgColor ?? const Color(0xFF2D2D2D);
    primaryTextColor = newConfig?.primaryTextColor ?? Colors.white;
    secondaryTextColor = newConfig?.secondaryTextColor ?? Colors.grey;
    iconColor = newConfig?.iconColor ?? Colors.white;
    secondaryIconColor = newConfig?.secondaryIconColor ?? const Color(0xFFB71C1C);
    accentColor = newConfig?.accentColor ?? Colors.orange;
    dividerColor = newConfig?.dividerColor ?? Colors.grey;
    errorColor = newConfig?.errorColor ?? const Color(0xFFB71C1C);
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
    textFormFieldConfig =
        newConfig?.textFormFieldConfig ?? const AnbocasTextFormFieldConfig();

    ticketCardConfig =
        newConfig?.ticketCardConfig ?? const AnbocasTicketCardConfig();

    qrcodeColor = newConfig?.qrcodeColor;

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

class AnbocasTicketCardConfig {
  const AnbocasTicketCardConfig({
    this.ticketCardBackgroundColor = const Color(0xFF2D2D2D),
    this.selectedTicketCardBorderColor = const Color(0xFFB71C1C),
    this.qtyAddIconColor = Colors.black,
    this.qtyAddBackgroundColor = const Color(0xFFB71C1C),
    this.qtyReduceIconColor = Colors.black,
    this.qtyReduceBackgroundColor = const Color(0xFF5F5F5F),
    this.dottedLineColor = const Color(0xFF5F5F5F),
    this.priceStyle = const TextStyle(color: Colors.white, fontSize: 12),
    this.nameStyle = const TextStyle(color: Colors.white, fontSize: 12),
    this.descriptionStyle =
        const TextStyle(color: Color(0xFFBCBCBC), fontSize: 12),
    this.labelStyle = const TextStyle(color: Color(0xFFBCBCBC), fontSize: 14),
  });

  // colors

  final Color ticketCardBackgroundColor;
  final Color selectedTicketCardBorderColor;
  final Color qtyAddIconColor;
  final Color qtyAddBackgroundColor;
  final Color qtyReduceIconColor;
  final Color qtyReduceBackgroundColor;
  final Color dottedLineColor;

// text styles
  final TextStyle priceStyle;
  final TextStyle nameStyle;
  final TextStyle descriptionStyle;
  final TextStyle labelStyle;
}

class AnbocasTextFormFieldConfig {
  const AnbocasTextFormFieldConfig({
    this.cursorColor = Colors.white,
    this.fillColor = Colors.transparent,
    this.labelStyle = const TextStyle(color: Colors.white, fontSize: 12),
    this.hintStyle = const TextStyle(color: Colors.grey, fontSize: 14),
    this.style = const TextStyle(color: Colors.white, fontSize: 14),
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    this.border = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.0),
    ),
    this.errorBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFB71C1C), width: 1.0),
    ),
    this.focusedBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.0),
    ),
    this.inputBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.0),
    ),
    this.enabledBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.0),
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
