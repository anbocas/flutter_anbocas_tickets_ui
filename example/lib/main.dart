import 'package:anbocas_flutter_ticket_booking_example/company_listing_screen.dart';
import 'package:anbocas_flutter_ticket_booking_example/detail_event_screen.dart';
import 'package:anbocas_flutter_ticket_booking_example/event_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:anbocas_tickets_api/anbocas_tickets_api.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AnbocasTicketsApi.instance
        ?.config(token: dotenv.env['API_KEY'], enableLog: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anbocas Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.langarTextTheme(
            Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.black, displayColor: Colors.black),
          ),
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              inversePrimary: Colors.black,
              onPrimary: Colors.white),
          useMaterial3: true,
        ),
        initialRoute: "/",
        routes: <String, WidgetBuilder>{
          "/": (BuildContext context) {
            return const CompanyListingScreen();
          },
          "eventListing": (BuildContext context) {
            final model = ModalRoute.of(context)!.settings.arguments
                as AnbocasCompanyModel;
            return EventListingScreen(
              company: model,
            );
          },
          "eventDetail": (BuildContext context) {
            final model =
                ModalRoute.of(context)!.settings.arguments as AnbocasEventModel;
            return DetailEventScreen(
              model: model,
            );
          },
        });
  }
}
