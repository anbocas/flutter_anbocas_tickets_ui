import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/anbocas_flutter_ticket_booking.dart';
import 'package:anbocas_tickets_ui/src/components/custom_button.dart';
import 'package:anbocas_tickets_ui/src/components/dottted_line.dart';
import 'package:anbocas_tickets_ui/src/components/icon_with_circle_background.dart';
import 'package:anbocas_tickets_ui/src/components/ticket_card_clipper.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/model/single_ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TicketItemWidget extends StatefulWidget {
  const TicketItemWidget({
    super.key,
    required this.element,
    this.isSelected = false,
    this.showBuyButton = false,
    this.showDeleteIcon = false,
    required this.onQuantityChanged,
    this.onDeletePres,
    this.onBuyItemPressed,
    this.onItemSelect,
  });

  final SingleTicket element;
  final bool isSelected;
  final bool showBuyButton;
  final bool showDeleteIcon;
  final void Function(int newQuantity, String ticketId) onQuantityChanged;
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
    // if (oldWidget.isSelected != widget.isSelected) {
    //   quantity.value = 1;
    //   widget.onQuantityChanged(quantity.value);
    // }
    // if (oldWidget.element != widget.element) {
    //   quantity.value = widget.element.selectedQuantity;
    //   widget.onQuantityChanged(quantity.value);
    // }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      height: 150.v,
      width: double.infinity,
      decoration: BoxDecoration(
          color: widget.isSelected == true
              ? theme.selectedTicketBorderColor
              : null),
      child: CustomPaint(
        painter: TicketCardFillPainter(radius: 15, isSelected: true),
        child: ClipPath(
          clipper: TicketCardClipper(radius: 15),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: widget.isSelected == true
                  ? Border.all(
                      color: theme.selectedTicketBorderColor!,
                      width: 2.adaptSize)
                  : const Border(),
              color: theme.ticketBackgroundColor,
            ),
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
                      ],
                    ),
                  ),
                ),
              ),
              CustomPaint(
                painter: DottedLine(radius: 20),
                child: const SizedBox(
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.v, horizontal: 20.h),
                child: widget.element.available > 0
                    ? Row(
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
                                if (quantity.value > 0) {
                                  quantity.value--;
                                  widget.onQuantityChanged(
                                      quantity.value, widget.element.id!);
                                }
                              },
                              color:
                                  theme.secondaryIconColor!.withOpacity(0.5)),
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
                                if (quantity.value <= 9) {
                                  quantity.value++;
                                  widget.onQuantityChanged(
                                      quantity.value, widget.element.id!);
                                }
                              },
                              icon: Icons.add,
                              color: theme.secondaryIconColor!),
                        ],
                      )
                    : Text("Out of Stock",
                        style: theme.labelStyle?.copyWith(color: Colors.red)),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
