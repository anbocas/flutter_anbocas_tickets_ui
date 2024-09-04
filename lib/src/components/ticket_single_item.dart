import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/anbocas_flutter_ticket_booking.dart';
import 'package:anbocas_tickets_ui/src/components/dottted_line.dart';
import 'package:anbocas_tickets_ui/src/components/icon_with_circle_background.dart';
import 'package:anbocas_tickets_ui/src/components/ticket_card_clipper.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/model/single_ticket.dart';
import 'package:flutter/material.dart';

class TicketItemWidget extends StatefulWidget {
  const TicketItemWidget({
    super.key,
    required this.element,
    this.isSelected = false,
    this.showBuyButton = false,
    this.showDeleteIcon = false,
    required this.onQuantityChanged,
    this.onDeletePres,
 
    this.onItemSelect,
  });

  final SingleTicket element;
  final bool isSelected;
  final bool showBuyButton;
  final bool showDeleteIcon;
  final void Function(int newQuantity, String ticketId) onQuantityChanged;
  final void Function()? onDeletePres;
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
      height: 180.v,
      width: double.infinity,
      decoration: BoxDecoration(
          color: widget.isSelected == true
              ? theme.ticketCardConfig.selectedTicketCardBorderColor
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
                      color:
                          theme.ticketCardConfig.selectedTicketCardBorderColor,
                      width: 2.adaptSize)
                  : const Border(),
              color: theme.ticketCardConfig.ticketCardBackgroundColor,
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
                              child: Text(widget.element.name ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.ticketCardConfig.nameStyle),
                            ),
                            SizedBox(
                              width: 20.h,
                            ),
                            Text(widget.element.formattedPrice ?? "",
                                style: theme.ticketCardConfig.priceStyle),
                          ],
                        ),
                        SizedBox(
                          height: 10.v,
                        ),
                        Text(
                          widget.element.description ?? "",
                          style: theme.ticketCardConfig.labelStyle
                              .copyWith(overflow: TextOverflow.ellipsis),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomPaint(
                painter: DottedLine(
                    radius: 20, color: theme.ticketCardConfig.dottedLineColor),
                child: const SizedBox(
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.v, horizontal: 20.h),
                child: (widget.element.available != 0)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Quantity",
                            style: theme.ticketCardConfig.labelStyle,
                          ),
                          SizedBox(
                            width: 10.h,
                          ),
                          Row(
                            children: [
                              IconWithCircleBackground(
                                  icon: Icons.remove,
                                  onPressed: () {
                                    if (quantity.value > 0) {
                                      quantity.value--;
                                      widget.onQuantityChanged(
                                          quantity.value, widget.element.id!);
                                    }
                                  },
                                  color: theme.ticketCardConfig
                                      .qtyReduceBackgroundColor),
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
                                  color: theme
                                      .ticketCardConfig.qtyAddBackgroundColor),
                            ],
                          )
                        ],
                      )
                    : Text("Sold Out!",
                        style: theme.ticketCardConfig.labelStyle
                            .copyWith(color: theme.errorColor)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
