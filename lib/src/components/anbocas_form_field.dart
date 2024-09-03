// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';
import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnbocasFormField extends StatefulWidget {
  const AnbocasFormField(
      {Key? key,
      required this.formCtr,
      this.hintText = "Type Here",
      this.labelText,
      this.inputAction = TextInputAction.next,
      this.inputType = TextInputType.text,
      this.fieldValidator,
      this.maxLength,
      this.showCountryPicker = false,
      this.countryCode,
      this.onCountryChanged,
      this.inputFormatters,
      this.filled = true,
      this.readOnly = false,
      this.maxLines = 1,
      this.minLines = 1,
      this.onTap})
      : assert(
            !showCountryPicker ||
                (showCountryPicker && onCountryChanged != null),
            'onChanged callback must be provided when showCountryPicker is true'),
        super(key: key);

  final TextEditingController formCtr;
  final String hintText;
  final String? labelText;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final String? Function(String?)? fieldValidator;
  final int? maxLength;
  final bool showCountryPicker;
  final String? countryCode;
  final void Function(CountryCode)? onCountryChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool filled;

  final void Function()? onTap;
  final bool? readOnly;
  final int? maxLines;
  final int? minLines;

  @override
  State<AnbocasFormField> createState() => _AnbocasFormFieldState();
}

class _AnbocasFormFieldState extends State<AnbocasFormField> {
  final GlobalKey _countryPickerKey = GlobalKey();
  double textInputPaddingLeft = 0.0;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: 1,
      maxLines: widget.maxLines,
      controller: widget.formCtr,
      cursorColor: theme.textFormFieldConfig?.cursorColor,
      selectionHeightStyle: BoxHeightStyle.includeLineSpacingBottom,
      validator: widget.fieldValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: theme.textFormFieldConfig?.style,
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      readOnly: widget.readOnly!,
      onTap: widget.onTap,
      decoration: InputDecoration(
        filled: widget.filled,
        counterText: "",
        prefixIcon: widget.showCountryPicker
            ? CountryCodePicker(
                onChanged: (code) {
                  // textInputPaddingLeft =
                  //     _countryPickerKey.currentContext?.size?.width;
                  if (widget.onCountryChanged != null) {
                    widget.onCountryChanged?.call(code);
                  }
                },
                builder: (countryCode) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          countryCode?.flagUri ?? "",
                          package: 'country_code_picker',
                          width: 25.h,
                          height: 25.v,
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          countryCode?.dialCode ?? "",
                          style: theme.bodyStyle
                              ?.copyWith(height: 1.1, fontSize: 14.fSize),
                        ),
                      ],
                    ),
                  );
                },
                initialSelection: widget.countryCode ?? 'IN',
                favorite: const ['+91', 'IN'],
                searchDecoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: theme.textFormFieldConfig?.focusedBorder,
                  errorBorder: theme.textFormFieldConfig?.errorBorder,
                  enabledBorder: theme.textFormFieldConfig?.enabledBorder,
                ),
                searchStyle: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(height: 1.1, color: Colors.black),
                dialogTextStyle:
                    theme.labelStyle?.copyWith(color: Colors.black),
                flagWidth: 25.h,
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                dialogBackgroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.transparent,
              )
            : null,
        fillColor: theme.textFormFieldConfig?.fillColor,
        hintText: widget.hintText,
        labelText: widget.labelText,
        contentPadding: theme.textFormFieldConfig?.contentPadding,
        labelStyle: theme.textFormFieldConfig?.labelStyle,
        hintStyle: theme.textFormFieldConfig?.hintStyle,
        border: theme.textFormFieldConfig?.border,
        focusedBorder: theme.textFormFieldConfig?.focusedBorder,
        errorBorder: theme.textFormFieldConfig?.errorBorder,
        enabledBorder: theme.textFormFieldConfig?.enabledBorder,
      ),
    );
  }
}
