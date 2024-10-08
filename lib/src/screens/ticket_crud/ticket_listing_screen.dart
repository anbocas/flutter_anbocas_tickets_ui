import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:anbocas_tickets_ui/src/anbocas_flutter_ticket_booking.dart';
import 'package:anbocas_tickets_ui/src/components/anbocas_form_field.dart';
import 'package:anbocas_tickets_ui/src/components/custom_button.dart';
import 'package:anbocas_tickets_ui/src/helper/common_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/size_utils.dart';
import 'package:anbocas_tickets_ui/src/model/ticket_by_event_response.dart';
import 'package:flutter/material.dart';
import 'package:anbocas_tickets_api/anbocas_tickets_api.dart';
import 'package:intl/intl.dart';

class TicketListingScreen extends StatefulWidget {
  final String eventId;

  const TicketListingScreen({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  TicketsScreenState createState() => TicketsScreenState();
}

class TicketsScreenState extends State<TicketListingScreen> {
  final _ticketsApi = AnbocasTicketsApi.ticket;
  final _eventApi = AnbocasTicketsApi.event;
  final ValueNotifier<List<SingleTicketByEvent>> _ticketsNotifier =
      ValueNotifier([]);
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(true);

  final ValueNotifier<AnbocasEventModel?> _eventDetails = ValueNotifier(null);
  DateTime? eventEndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchTickets() async {
    try {
      final response =
          await _ticketsApi.get(eventId: widget.eventId, paginate: false);
      TicketByEventData tickets = TicketByEventData.fromJson(response);

      final tempTickets = tickets.data!;
      tempTickets.sort((a, b) => b.available.compareTo(a.available));
      _ticketsNotifier.value = tempTickets;
    } catch (e) {
      _isLoadingNotifier.value = false;
      debugPrint(e.toString());
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  Future<void> _fetchEvents() async {
    try {
      _eventDetails.value =
          await _eventApi.eventDetails(eventId: widget.eventId);
      if (_eventDetails.value != null) {
        eventEndDate = DateTime.tryParse(_eventDetails.value!.endDate!);
        _fetchTickets();
      } else {
        _isLoadingNotifier.value = false;
      }
    } catch (e) {
      _isLoadingNotifier.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red, content: Text('Invalid Event ID')),
      );
      debugPrint(e.toString());
    }
  }

  Future<void> _addOrUpdateTicket({SingleTicketByEvent? ticket}) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ScaffoldMessenger(
        child: Builder(builder: (context) {
          return TicketDialog(
            ticket: ticket,
            event: _eventDetails.value!,
            eventDateTime: eventEndDate!,
          );
        }),
      ),
    );

    if (result == true) {
      _fetchTickets();
    }
  }

  Future<void> _deleteTicket(String ticketId) async {
    try {
      final result = await _ticketsApi.deleteTicket(ticketId: ticketId);
      if (result) {
        _fetchTickets();
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        title: Text(
          "Tickets",
          style: theme.headingStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: _iconBack(theme.iconColor!),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: theme.iconColor!,
            ),
            onPressed: () => _addOrUpdateTicket(),
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _isLoadingNotifier,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 4.adaptSize,
              color: theme.accentColor,
              backgroundColor: Colors.white,
            ));
          }

          return ValueListenableBuilder<List<SingleTicketByEvent>>(
            valueListenable: _ticketsNotifier,
            builder: (context, tickets, child) {
              return tickets.isEmpty
                  ? Center(
                      child: Text(
                        "No tickets found",
                        style: theme.bodyStyle,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.fromLTRB(22.h, 0, 22.h, 15.v),
                      child: ListView.separated(
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = tickets[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                                '${ticket.name}  (${ticket.formattedPrice})',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.subHeadingStyle),
                            subtitle: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.v),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Availability: ${ticket.getCurrentAvailablity()}',
                                    style: theme.labelStyle?.copyWith(
                                        color: theme.secondaryTextColor,
                                        fontSize: 12.fSize),
                                  ),
                                  SizedBox(
                                    height: 3.v,
                                  ),
                                  Text(
                                    'Status: ${ticket.status}',
                                    style: theme.labelStyle?.copyWith(
                                        color: theme.secondaryTextColor,
                                        fontSize: 12.fSize),
                                  ),

                                  // Text('Closes: ${ticket.getAvailableTo()}',
                                  //     style: theme.labelStyle),
                                ],
                              ),
                            ),
                            leading: Text(
                              '${index + 1}.',
                              style: theme.bodyStyle?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.fSize,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  child: Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: theme.iconColor,
                                  ),
                                  onTap: () =>
                                      _addOrUpdateTicket(ticket: ticket),
                                ),
                                SizedBox(
                                  width: 10.h,
                                ),
                                InkWell(
                                  child: const Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  onTap: () => _deleteTicket(ticket.id ?? ""),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            color: theme.dividerColor,
                          );
                        },
                      ),
                    );
            },
          );
        },
      ),
    );
  }

  Icon _iconBack(Color color) =>
     Icon(
              Icons.arrow_back,
              color: color,
            );
}

class TicketDialog extends StatefulWidget {
  final AnbocasEventModel event;
  final DateTime eventDateTime;
  final SingleTicketByEvent? ticket;

  TicketDialog(
      {this.ticket, required this.event, required this.eventDateTime});

  @override
  TicketDialogState createState() => TicketDialogState();
}

class TicketDialogState extends State<TicketDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _capacity = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _availableFrom = TextEditingController();
  final TextEditingController _availableTo = TextEditingController();
  DateTime? availableFrom;
  DateTime? availableTo;
  String? _selectedStatus = 'AVAILABLE';
  final ValueNotifier<bool> _unlimitedCheckbox = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    if (widget.ticket != null) {
      _name.text = widget.ticket?.name ?? "";
      _description.text = widget.ticket?.description ?? "";
      _capacity.text = widget.ticket!.capacity.toString();

      _unlimitedCheckbox.value = widget.ticket?.capacity == -1;

      _price.text = widget.ticket!.price.toString();
      _selectedStatus = widget.ticket!.status;

      availableFrom = DateTime.parse(widget.ticket!.availableFrom!);
      availableTo = DateTime.parse(widget.ticket!.availableTo!);

      _availableFrom.text =
          DateFormat('yyyy-MM-dd H:mm').format(availableFrom!);
      _availableTo.text = DateFormat('yyyy-MM-dd H:mm').format(availableTo!);
    }

    if (widget.ticket == null) {
      availableFrom = DateTime.now();
      availableTo = DateTime.parse(widget.event.endDate!);

      _capacity.text = '0';

      _availableFrom.text =
          DateFormat('yyyy-MM-dd H:mm').format(availableFrom!);
      _availableTo.text = DateFormat('yyyy-MM-dd H:mm').format(availableTo!);
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final api = AnbocasTicketsApi.ticket;

      if (widget.ticket == null) {
        await api.createTicket(
          eventId: widget.event.id!,
          name: _name.text,
          description: _description.text,
          capacity: _capacity.text,
          price: _price.text,
          availableFrom: _availableFrom.text,
          availableTo: _availableTo.text,
          status: _selectedStatus ?? "",
        );
      } else {
        await api.updateTicket(
          ticketId: widget.ticket!.id!,
          name: _name.text,
          description: _description.text,
          capacity: _capacity.text,
          price: _price.text,
          availableFrom: _availableFrom.text,
          availableTo: _availableTo.text,
          status: _selectedStatus ?? "",
        );
      }
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _pickDateTime({
    required TextEditingController controller,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        final dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onSelected(dateTime);
        setState(() {
          controller.text = dateTime.toString();
        });
      }
    }
  }

  Future<void> _pickAvailableFrom() async {
    if (widget.eventDateTime.isAfter(DateTime.now())) {
      await _pickDateTime(
        controller: _availableFrom,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: widget.eventDateTime,
        onSelected: (dateTime) {
          availableFrom = dateTime;
        },
      );
    }
  }

  Future<void> _pickAvailableTo() async {
    if (_availableFrom.text == '') {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       backgroundColor: Colors.red,
      //       content: Text('Please select the available from date first')),
      // );
      return;
    }

    await _pickDateTime(
      controller: _availableTo,
      initialDate: availableFrom!,
      firstDate: availableFrom!,
      lastDate: widget.eventDateTime,
      onSelected: (dateTime) {
        if (dateTime.isAfter(availableFrom!)) {
          availableTo = dateTime;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                    'Available to should be after the available form Date time.')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: theme.secondaryBgColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.ticket == null ? 'Add Ticket' : 'Update Ticket',
                  style: theme.headingStyle,
                ),
                SizedBox(
                  height: 15.v,
                ),
                AnbocasFormField(
                  formCtr: _name,
                  labelText: "Ticket Name",
                  filled: false,
                  // style: theme.bodyStyle?.copyWith(color: Colors.black),
                  hintText: "Type Here",
                  fieldValidator: (newValue) {
                    if (newValue == null || newValue.isEmpty) {
                      return "Name is required";
                    }
                    if (newValue.length < 3) {
                      return "Ticket name should be long";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15.v,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                          valueListenable: _unlimitedCheckbox,
                          builder: (context, loading, child) {
                            return AnbocasFormField(
                              formCtr: _capacity,
                              filled: false,
                              readOnly: _unlimitedCheckbox.value,
                              // style: theme.bodyStyle?.copyWith(color: Colors.black),
                              labelText: "Capacity",
                              hintText: "0",
                              inputType: const TextInputType.numberWithOptions(
                                  signed: true),
                              fieldValidator: (newValue) {
                                if (newValue == null || newValue.isEmpty) {
                                  return "Capacity is required";
                                }
                                if (newValue == '0') {
                                  return "Capacity can not be 0";
                                }
                                return null;
                              },
                            );
                          }),
                    ),
                    SizedBox(
                      width: 10.h,
                    ),
                    Row(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: _unlimitedCheckbox,
                            builder: (context, loading, child) {
                              return Checkbox(
                                onChanged: (value) {
                                  _unlimitedCheckbox.value = value!;
                                  if (value == true) {
                                    _capacity.text = '-1';
                                  } else {
                                    _capacity.text = '0';
                                  }
                                },
                                value: _unlimitedCheckbox.value,
                                activeColor: theme.primaryColor,
                              );
                            }),
                        Text(
                          'Unlimited',
                          style: theme.labelStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.v,
                ),
                AnbocasFormField(
                  formCtr: _price,
                  filled: false,
                  // style: theme.bodyStyle?.copyWith(color: Colors.black),
                  labelText: "Price",
                  hintText: "0.0",
                  inputType:
                      const TextInputType.numberWithOptions(signed: false),

                  fieldValidator: (newValue) {
                    if (newValue == null || newValue.isEmpty) {
                      return "Price is required";
                    }
                    if (!isValidPrice(newValue)) {
                      return "Invalid Price format.";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15.v,
                ),
                GestureDetector(
                  onTap: () => _pickAvailableFrom(),
                  child: AbsorbPointer(
                    child: AnbocasFormField(
                      readOnly: true,
                      formCtr: _availableFrom,
                      filled: false,
                      // style: theme.bodyStyle?.copyWith(color: Colors.black),
                      labelText: "Available From",
                      hintText: "Select Date",
                      fieldValidator: (newValue) {
                        if (newValue == null || newValue.isEmpty) {
                          return "Available from date is required";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.v,
                ),
                GestureDetector(
                  onTap: () => _pickAvailableTo(),
                  child: AbsorbPointer(
                    child: AnbocasFormField(
                      readOnly: true,
                      formCtr: _availableTo,
                      filled: false,
                      // style: theme.bodyStyle?.copyWith(color: Colors.black),
                      labelText: "Available To",
                      hintText: "Select Date",
                      fieldValidator: (newValue) {
                        if (newValue == null || newValue.isEmpty) {
                          return "Available to date is required";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.v,
                ),
                Visibility(
                  visible: false,
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: ['AVAILABLE', 'OUT_OF_STOCK'].map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(
                          status,
                          style: theme.textFormFieldConfig.style,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Status",
                      labelStyle: theme.textFormFieldConfig.labelStyle,
                      border: theme.textFormFieldConfig.border,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Status is required";
                      }
                      return null;
                    },
                  ),
                ),
                // SizedBox(
                //   height: 15.v,
                // ),
                AnbocasFormField(
                  formCtr: _description,
                  filled: false,
                  // style: theme.bodyStyle,
                  labelText: "Description",
                  maxLines: 4,
                  minLines: 2,

                  inputAction: TextInputAction.newline,
                  inputType: TextInputType.multiline,
                ),
                SizedBox(
                  height: 15.v,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    CustomButton(
                      onPressedCallback: _submit,
                      centerText: widget.ticket == null ? 'Add' : 'Update',
                      buttonSize: Size(100.h, 40.v),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      // actions: [

      // ],
    );
  }
}
