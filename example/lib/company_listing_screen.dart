import 'package:anbocas_tickets_api/anbocas_tickets_api.dart';
import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

class CompanyListingScreen extends StatefulWidget {
  const CompanyListingScreen({super.key});

  @override
  State<CompanyListingScreen> createState() => _CompanyListingScreenState();
}

class _CompanyListingScreenState extends State<CompanyListingScreen> {
  late Future<List<AnbocasCompanyModel>> _eventsFuture;

  @override
  void initState() {
    _eventsFuture = fetchEvents();
    AnbocasTickets.instance.config(
      anbocasRazorpayApiKey: dotenv.env['RZP_API_KEY'] ?? "",
      apikey: dotenv.env['API_KEY'] ?? "",
      customThemeConfig: AnbocasCustomTheme(
        backgroundColor: Color(0xFF151313),
        primaryColor: const Color(0xFFB71C1C),
        accentColor: Color(0xFFB71C1C),
        secondaryBgColor: Color(0xFF2D2D2D),
        secondaryTextColor: Colors.white,
        qrcodeColor: Colors.white,
        headingStyle: GoogleFonts.poppins().copyWith(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        subHeadingStyle: GoogleFonts.poppins().copyWith(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        bodyStyle: GoogleFonts.poppins().copyWith(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        labelStyle: GoogleFonts.poppins().copyWith(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        smallLabelStyle: GoogleFonts.poppins().copyWith(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
        ticketCardConfig: AnbocasTicketCardConfig(
          ticketCardBackgroundColor: Color(0xFF2D2D2D),
          selectedTicketCardBorderColor: Color(0xFFB71C1C),
          qtyAddBackgroundColor: Color(0xFFB71C1C),
          nameStyle: GoogleFonts.poppins().copyWith(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          priceStyle: GoogleFonts.poppins().copyWith(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          descriptionStyle: GoogleFonts.poppins().copyWith(
              color: Color(0xFFBCBCBC),
              fontSize: 12,
              fontWeight: FontWeight.w500),
          labelStyle: GoogleFonts.poppins().copyWith(
              color: Color(0xFFBCBCBC),
              fontSize: 14,
              fontWeight: FontWeight.w500),
          dottedLineColor: Color(0xFF5F5F5F),
        ),
        textFormFieldConfig: AnbocasTextFormFieldConfig(
            cursorColor: Colors.white,
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
    AnbocasEventManager.instance.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          "Company List",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: FutureBuilder<List<AnbocasCompanyModel>>(
          future: _eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                  child: Text("No event Found for the Company"));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  var element = snapshot.data![index];
                  return InkWell(
                    onTap: () => Navigator.pushNamed(context, "eventListing",
                        arguments: element),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 225, 217, 217),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              if (element.logo != null &&
                                  element.logo!.contains("http"))
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    element.logo ?? "",
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.fill,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.white, // Icon color
                                            size: 36,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                            ],
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              element.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<AnbocasCompanyModel>> fetchEvents() async {
    try {
      var response = await AnbocasTicketsApi.company
          .get(CompanyGetRequest(paginate: false));
      if (response != null) {
        return response;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }
}
