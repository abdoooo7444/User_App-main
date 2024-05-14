// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_second/Pages/home_page.dart';
import 'package:project_second/Pages/show_page.dart';
import 'package:project_second/models/properties.dart';
import 'package:project_second/services/property_api_service.dart';

class ShowResdential extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ShowResdential> {
  List<Property> resdintial = [];

  bool isloading = true;

  int currentIndex = 0; // Add a default value

  Future<void> getResidential() async {
    try {
      setState(() {
        isloading = true;
      });
      final data = await ApiServices().getcommercials();
      resdintial = data;
      setState(() {
        isloading = false;
      });
    } catch (e) {}
  }

  final TextEditingController _addressController = TextEditingController();

  Future<Property?> _searchCommercialProperty(String address) async {
    try {
      final data = await ApiServices().getSingleResdentialByAddress(address);
      if (data != null) {
        return data;
      } else {
        return null;
      }
    } catch (error) {
      print("Error fetching commercial property: $error");
      return null; // Indicate error
    }
  }

  void _handleSearchButtonPressed() async {
    String address = _addressController.text.trim();
    if (address.isEmpty) {
      print("Please enter an address to search.");
      return; // Exit early if address is empty
    }

    try {
      Property? property = await _searchCommercialProperty(address);
      if (property != null) {
        // Convert Property object to Map<String, dynamic>
        Map<String, dynamic> propertyMap = {
          'propertyaddress': property.propertyaddress,
          'image': property.image,
          'status': property.status,
          'kind': property.kind,
          'moreDetails': property.moreDetails,
          'phoneNmber': property.phoneNmber,
          'price': property.price,
          'rentDuration': property.rentDuration,
          'type': property.type,
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleProperty(data: propertyMap),
          ),
        );
        print("Found commercial property: ${property.propertyaddress}");
      } else {
        print("No commercial property found at $address");
      }
    } catch (error) {
      print("Error searching for commercial property: $error");
      // Optionally, display an error message to the user
    }
  }

  @override
  void initState() {
    getResidential();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(top: 20.0, left: 8.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Color.fromRGBO(118, 165, 209, 1),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ));
                    },
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontFamily: "Inria Serif",
                            ),
                            hintText: 'address you want to search about ',
                            icon: Icon(Icons.search),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: _handleSearchButtonPressed,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: resdintial.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleProperty(
                                  data: resdintial[index].toMap(),
                                ),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                width: double.infinity,
                                color: Colors.grey[200],
                                // child:
                                //     Image.asset('images/images/whatsapp.png'),
                                // Image.network(
                                //   '${resdintial[index].image}',
                                //   height: 150,
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  height: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            '${resdintial[index].kind}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Inria Serif"),
                                          ),
                                        ),
                                        Text(
                                          '${resdintial[index].propertyaddress}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "starting from ",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Inria Serif"),
                                          ),
                                        ),
                                        Text(
                                          '${resdintial[index].price} \$',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Inria Serif",
                                              color: Color.fromARGB(
                                                  255, 13, 71, 119)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
