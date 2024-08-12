import 'package:anbocas_tickets_api/anbocas_tickets_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListingScreen extends StatefulWidget {
  final CompanyModel company;
  const EventListingScreen({
    Key? key,
    required this.company,
  }) : super(key: key);

  @override
  State<EventListingScreen> createState() => _EventListingScreenState();
}

class _EventListingScreenState extends State<EventListingScreen> {
  late Future<List<EventModel>> _eventsFuture;

  @override
  void initState() {
    _eventsFuture = fetchEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          widget.company.name ?? "",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: FutureBuilder<List<EventModel>>(
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
                    onTap: () {
                      Navigator.pushNamed(context, "eventDetail",
                          arguments: element);
                    },
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
                              if (element.imageUrl != null &&
                                  element.imageUrl!.contains("http"))
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    element.imageUrl ?? "",
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.fill,
                                  ),
                                )
                            ],
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  element.name ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  convertToReadable(element.startDate ?? ""),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                    text: TextSpan(children: [
                                  const WidgetSpan(
                                      child: Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                    size: 18,
                                  )),
                                  TextSpan(
                                      text: element.location ?? "",
                                      style:
                                          const TextStyle(color: Colors.grey))
                                ]))
                              ],
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

  Future<List<EventModel>> fetchEvents() async {
    try {
      var response = await AnbocasRequestPlugin.event
          .get(companyId: widget.company.id ?? "", paginate: false);
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

String convertToReadable(String originalDate) {
  DateTime dateTime = DateTime.parse(originalDate);
  String dayOfWeek = DateFormat('E').format(dateTime);
  String month = DateFormat('MMM').format(dateTime);
  String day = DateFormat('dd').format(dateTime);
  String time = DateFormat('hh.mm a').format(dateTime);
  return '$dayOfWeek, $month $day - $time';
}
