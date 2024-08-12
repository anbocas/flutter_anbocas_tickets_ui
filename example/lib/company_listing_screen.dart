import 'package:anbocas_tickets_api/anbocas_tickets_api.dart';
import 'package:flutter/material.dart';

class CompanyListingScreen extends StatefulWidget {
  const CompanyListingScreen({super.key});

  @override
  State<CompanyListingScreen> createState() => _CompanyListingScreenState();
}

class _CompanyListingScreenState extends State<CompanyListingScreen> {
  late Future<List<CompanyModel>> _eventsFuture;

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
          "Company List",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: FutureBuilder<List<CompanyModel>>(
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

  Future<List<CompanyModel>> fetchEvents() async {
    try {
      var response = await AnbocasRequestPlugin.company
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
