import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/components/custom_button.dart';
import 'package:anbocas_tickets_ui/src/components/dottted_line.dart';
import 'package:anbocas_tickets_ui/src/components/icon_with_circle_background.dart';
import 'package:anbocas_tickets_ui/src/components/ticket_card_clipper.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/model/single_ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TicketItemWidget extends StatefulWidget {
  const TicketItemWidget(
      {super.key,
      required this.element,
      this.isSelected = false,
      this.showBuyButton = false,
      this.showDeleteIcon = false,
      required this.onQuantityChanged,
      this.onDeletePres,
      this.onBuyItemPressed,
      this.onItemSelect});

  final SingleTickets element;
  final bool isSelected;
  final bool showBuyButton;
  final bool showDeleteIcon;
  final ValueChanged<int> onQuantityChanged;
  final void Function()? onDeletePres;
  final void Function()? onBuyItemPressed;
  final void Function()? onItemSelect;
  @override
  State<TicketItemWidget> createState() => _TicketItemWidgetState();
}

class _TicketItemWidgetState extends State<TicketItemWidget> {
  late ValueNotifier<int> quantity;

  @override
  void initState() {
    quantity = ValueNotifier(widget.element.selectedQuantity);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TicketItemWidget oldWidget) {
    if (oldWidget.isSelected != widget.isSelected) {
      quantity.value = 1;
      widget.onQuantityChanged(quantity.value);
    }
    if (oldWidget.element != widget.element) {
      quantity.value = widget.element.selectedQuantity;
      widget.onQuantityChanged(quantity.value);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.isSelected || widget.showBuyButton) ? 180.v : 140.v,
      width: double.infinity,
      decoration: BoxDecoration(
          color: widget.isSelected == true ? theme.accentColor : null),
      child: CustomPaint(
        painter: TicketCardFillPainter(radius: 15, isSelected: true),
        child: ClipPath(
          clipper: TicketCardClipper(radius: 15),
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: widget.isSelected == true
                    ? Border.all(color: theme.accentColor!, width: 2.adaptSize)
                    : const Border(),
                color: theme.secondaryBgColor),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: (widget.showBuyButton) ? null : widget.onItemSelect,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.v, horizontal: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.element.name ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.bodyStyle?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.fSize,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.h,
                            ),
                            Text(widget.element.formattedPrice ?? "",
                                style: theme.bodyStyle)
                          ],
                        ),
                        SizedBox(
                          height: 10.v,
                        ),
                        HtmlWidget(
                          widget.element.description ?? "",
                          textStyle: theme.smallLabelStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.isSelected || widget.showBuyButton)
                CustomPaint(
                  painter: DottedLine(radius: 20),
                  child: const SizedBox(
                    width: double.infinity,
                  ),
                ),
              if (widget.isSelected || widget.showBuyButton)
                Expanded(
                    child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.v, horizontal: 20.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.showBuyButton)
                        Padding(
                          padding: EdgeInsets.only(right: 10.0.h),
                          child: CustomButton(
                            onPressedCallback: widget.onBuyItemPressed,
                            centerText: "Buy Ticket",
                            buttonSize: Size(60.h, 40.v),
                          ),
                        ),
                      if (!widget.showBuyButton)
                        Row(
                          children: [
                            Text(
                              "Quantity",
                              style: theme.bodyStyle?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.fSize,
                                color: theme.secondaryTextColor,
                              ),
                            ),
                            SizedBox(
                              width: 10.h,
                            ),
                            // const Spacer(),
                            IconWithCircleBackground(
                                icon: Icons.remove,
                                onPressed: () {
                                  if (quantity.value >
                                          widget.element.minQtyPerOrder &&
                                      widget.isSelected == true) {
                                    quantity.value--;
                                    widget.onQuantityChanged(quantity.value);
                                  }
                                },
                                color:
                                    theme.secondaryBgColor!.withOpacity(0.9)),
                            SizedBox(
                              width: 10.h,
                            ),
                            ValueListenableBuilder<int>(
                                valueListenable: quantity,
                                builder: (context, quantity, child) {
                                  return Text(
                                    quantity.toString(),
                                    style: theme.labelStyle?.copyWith(
                                      color: theme.primaryTextColor,
                                    ),
                                  );
                                }),
                            SizedBox(
                              width: 10.h,
                            ),
                            IconWithCircleBackground(
                                onPressed: () {
                                  if (widget.element.maxQtyPerOrder >
                                          quantity.value &&
                                      widget.isSelected == true) {
                                    quantity.value++;
                                    widget.onQuantityChanged(quantity.value);
                                  }
                                },
                                icon: Icons.add,
                                color: theme.secondaryIconColor!),
                          ],
                        ),
                      if (widget.showDeleteIcon) const Spacer(),
                      if (widget.showDeleteIcon)
                        IconButton(
                            onPressed: widget.onDeletePres,
                            alignment: Alignment.center,
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.delete,
                              color: theme.secondaryIconColor,
                            ))
                    ],
                  ),
                ))
            ]),
          ),
        ),
      ),
    );
  }
}
