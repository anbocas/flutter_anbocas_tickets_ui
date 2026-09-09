import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/components/icon_with_circle_background.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final int maxLines;

  const ReadMoreText({
    super.key,
    required this.text,
    this.textStyle,
    this.maxLines = 3,
  });

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _isTextOverflowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkTextOverflow());
  }

  void _checkTextOverflow() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.textStyle),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width);

    setState(() {
      _isTextOverflowing = textPainter.didExceedMaxLines;
    });
  }

  void _showFullText() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.94,
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.v),
          color: theme.backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Description",
                    style: theme.ticketCardConfig.nameStyle,
                  ),
                  const Spacer(),
                  IconWithCircleBackground(
                      onPressed: () => Navigator.pop(context),
                      icon: Icons.close,
                      color: theme.ticketCardConfig.qtyAddBackgroundColor),
                ],
              ),
              SizedBox(
                height: 20.v,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget.text,
                    style: theme.ticketCardConfig.labelStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: widget.textStyle,
          maxLines: _isTextOverflowing ? widget.maxLines : null,
          overflow: _isTextOverflowing ? TextOverflow.ellipsis : null,
        ),
        if (_isTextOverflowing)
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _showFullText,
            child: Text('Read More',
                style: widget.textStyle?.copyWith(
                    color: theme.ticketCardConfig.qtyAddBackgroundColor)),
          ),
      ],
    );
  }
}
