import 'package:anbocas_tickets_api/anbocas_tickets_api.dart';
import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailEventScreen extends StatefulWidget {
  final AnbocasEventModel model;
  const DetailEventScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<DetailEventScreen> createState() => _DetailEventScreenState();
}

class _DetailEventScreenState extends State<DetailEventScreen> {
  final anbocas = AnbocasEventManager();

  @override
  void initState() {
    anbocas.on(AnbocasEventManager.eventBookingSuccess, handleBookingSuccess);

    AnbocasTickets.instance.config(
      apikey: dotenv.env['API_KEY'] ?? "",
      customThemeConfig: AnbocasCustomTheme(
        backgroundColor: Colors.black,
        primaryColor: const Color(0xFFB71C1C),
        
        secondaryBgColor: Colors.grey,
        secondaryTextColor: Colors.white,
        qrcodeColor: Colors.white,
        headingStyle:
            GoogleFonts.poppins().copyWith(color: Colors.white, fontSize: 18),
        subHeadingStyle:
            GoogleFonts.poppins().copyWith(color: Colors.white, fontSize: 16),
        bodyStyle: GoogleFonts.poppins()
            .copyWith(color: Colors.white, fontSize: 14),
        labelStyle:
            GoogleFonts.poppins().copyWith(color: Colors.white, fontSize: 12),
        buttonStyle: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFFB71C1C)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          minimumSize: WidgetStateProperty.all<Size>(
            const Size(double.infinity, 50),
          ),
        ),
        textFormFieldConfig: AnbocasTextFormFieldConfig(
            style: GoogleFonts.poppins()
                .copyWith(color: Colors.white, fontSize: 14),
            hintStyle: GoogleFonts.poppins()
                .copyWith(color: Colors.white, fontSize: 12),
            labelStyle: GoogleFonts.poppins()
                .copyWith(color: Colors.white, fontSize: 12),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    anbocas.clear();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  handleBookingSuccess(data) {
    debugPrint("-------------Listening the Booking Data-----------");
    debugPrint("--------------------------------------------------");
    debugPrint(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              pinned: true,
              centerTitle: false,
              stretch: true,
              expandedHeight: 280.0,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Stack(
                  children: [
                    Container(
                      height: 280,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 225, 217, 217),
                      ),
                    ),
                    if (widget.model.imageUrl != null &&
                        widget.model.imageUrl!.contains("http"))
                      Positioned.fill(
                        child: Image.network(
                          widget.model.imageUrl ?? "",
                          height: 280,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.model.name ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 24),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          margin: const EdgeInsets.only(right: 20),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 230, 226, 226),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_month,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                        Text.rich(TextSpan(
                            text: formatDate(widget.model.startDate!),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                            children: [
                              const TextSpan(text: "\n"),
                              TextSpan(
                                text: formatTime(widget.model.startDate!),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              )
                            ]))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    (widget.model.getLocationType() ==
                            EventLocationType.virtual)
                        ? Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(right: 20),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 230, 226, 226),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.group,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                              Expanded(
                                child: Text.rich(TextSpan(
                                    text: "Meeting Link",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                    children: [
                                      const TextSpan(text: "\n"),
                                      TextSpan(
                                        text: widget.model.meetingLink ?? "N/A",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      )
                                    ])),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(right: 20),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 230, 226, 226),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                              Text.rich(TextSpan(
                                  text: formatDate(widget.model.startDate!),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                  children: [
                                    const TextSpan(text: "\n"),
                                    TextSpan(
                                      text: formatTime(widget.model.startDate!),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    )
                                  ]))
                            ],
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    HtmlWidget(
                      widget.model.description ?? "",
                      onTapUrl: (url) async {
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                          return true;
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      buildAsync: true,
                      textStyle: const TextStyle(),
                    ),
                    const SizedBox(
                      height: 90,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.black),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        minimumSize: WidgetStateProperty.all<Size>(
                            const Size(double.infinity, 50)),
                      ),
                      // onPressed: () => AnbocasTickets.instance.manageTickets(
                      //       eventId: widget.model.id!,
                      //       context: context,
                      //     ),
                      onPressed: () =>
                          AnbocasTickets.instance.launchBookingFlow(
                            eventId: widget.model.id!,
                            context: context,
                            userMetaData: UserConfig(
                                name: "Saurabh Kumar",
                                email: "saurabhTester35@gmail.com",
                                phone: "9304678898",
                                countryCode: "+91"),
                                
                          ),
                          
                      // onPressed: () => AnbocasTickets.instance.manageAttendees(
                      //     context: context, eventId: widget.model.id ?? ""),
                      child: const Text(
                        "Buy Ticket",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),
                      )),
                ),
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.black),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        minimumSize: WidgetStateProperty.all<Size>(
                            const Size(double.infinity, 50)),
                      ),
                      onPressed: () => AnbocasTickets.instance.manageTickets(
                            eventId: widget.model.id!,
                            context: context,
                          ),
                      child: const Text(
                        "Manage Tickets",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),
                      )),
                ),
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.black),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        minimumSize: WidgetStateProperty.all<Size>(
                            const Size(double.infinity, 50)),
                      ),
                      onPressed: () => AnbocasTickets.instance.manageAttendees(
                          context: context, eventId: widget.model.id ?? ""),
                      child: const Text(
                        "Manage Attendies",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),
                      )),
                ),
              ],
            ))
      ],
    ));
  }

  String formatDate(String stringDate) {
    DateTime date = DateTime.parse(stringDate);
    return DateFormat('EEEE, MMMM d, y').format(date);
  }

  String formatTime(String stringDate) {
    DateTime date = DateTime.parse(stringDate);
    return DateFormat('h:mm a').format(date);
  }
}
