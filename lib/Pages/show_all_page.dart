import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_second/Pages/show_page.dart';
import 'package:project_second/models/properties.dart';
import 'package:project_second/services/property_api_service.dart';

class ShowProperty extends StatefulWidget {
  const ShowProperty({super.key});

  @override
  State<ShowProperty> createState() => _ShowPropertyState();
}

class _ShowPropertyState extends State<ShowProperty> {
  List<Property> commercial = [];
  List<Property> residential = [];
  bool isLoading = true;
  bool isResidential = true;

  @override
  void initState() {
    getCommercial();
    getResidential();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add your app bar content here
        title: Text('Property List'),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        isResidential ? residential.length : commercial.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Card(
                            color: Colors.white,
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  isResidential
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SingleProperty(
                                              data: residential[index].toMap(),
                                            ),
                                          ))
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SingleProperty(
                                              data: commercial[index].toMap(),
                                            ),
                                          ));
                                },
                                child: Container(
                                  width: 200,
                                  height: 300,
                                  child: Image.network(
                                    isResidential
                                        ? '${residential[index].image}'
                                        : '${commercial[index].image}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                isResidential
                                    ? '${residential[index].type}'
                                    : '${commercial[index].type}',
                              ),
                              subtitle: Text(
                                isResidential
                                    ? '${residential[index].status} \n ${residential[index].propertyaddress} \n ${residential[index].moreDetails} \n${residential[index].rentDuration}'
                                    : '${commercial[index].status} \n ${commercial[index].propertyaddress} \n ${commercial[index].moreDetails} \n ${commercial[index].rentDuration}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    isResidential
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SingleProperty(
                                                data:
                                                    residential[index].toMap(),
                                              ),
                                            ))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SingleProperty(
                                                data: commercial[index].toMap(),
                                              ),
                                            ));
                                  },
                                  icon: const Icon(
                                    Icons.expand_circle_down,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            isResidential = false;
                            getCommercial();
                            commercial.clear();
                          });
                        },
                        child: const Text(
                          'Commercial',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            isResidential = true;
                            getResidential();
                            residential.clear();
                          });
                        },
                        child: const Text('Residential',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> getResidential() async {
    try {
      setState(() {
        isLoading = true;
      });
      final data = await ApiServices().getResidential();
      residential = data;
      setState(() {
        isLoading = false;
      });
    } catch (e) {}
  }

  Future<void> getCommercial() async {
    try {
      setState(() {
        isLoading = true;
      });
      final data = await ApiServices().getResidential();
      commercial = data;
      setState(() {
        isLoading = false;
      });
    } catch (e) {}
  }
}
