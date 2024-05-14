import 'package:flutter/material.dart';
import 'package:project_second/Pages/home_page.dart';
import 'package:project_second/Pages/show_page.dart';
import 'package:project_second/models/properties.dart';
import 'package:project_second/services/property_api_service.dart';

class ShowCommercial extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ShowCommercial> {
  List<Property> comercical = [];
  bool isloading = true;

  int currentIndex = 0; // Add a default value
  Future<void> getcommercials() async {
    try {
      setState(() {
        isloading = true;
      });
      final data = await ApiServices().getcommercials();
      comercical = data;
      setState(() {
        isloading = false;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    getcommercials();
    super.initState();
  }

  // Dummy _changeItem method, replace it with your logic
  // void _changeItem(int index) {
  //   setState(() {
  //     currentIndex = index;
  //   });
  // }

  final TextEditingController _addressController = TextEditingController();

  Future<Property?> _searchCommercialProperty(String address) async {
    try {
      final data = await ApiServices().getSingleCommercialByAddress(address);
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
          'kind': property.kind,
          'moreDetails': property.moreDetails,
          'phoneNmber': property.phoneNmber,
          'price': property.price,
          'rentDuration': property.rentDuration,
          'type': property.type,
          'image': property.status,

          // Map properties to data
          // Add other mappings based on your Property object's fields
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == true
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 20.0, left: 8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Color.fromRGBO(118, 165, 209, 1),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
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
                SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: comercical.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleProperty(
                                  data: comercical[index].toMap()),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: Column(
                            children: [
                              // Container(
                              //   padding: EdgeInsets.all(2),
                              //   width: double.infinity,
                              //   color: Colors.grey[200],
                              //   //  child:
                              //   // Image.asset(
                              //   //   ' Image.asset(images/image/phone.png',
                              //   //   height: 46.5,
                              //   //   width: 50,
                              //   ), // Image.network(
                              //   //   '${comercical[index].image}',
                              //   //   height: 150,
                              //   //   fit: BoxFit.cover,
                              //   // ),
                              // ),
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
                                            '${comercical[index].type}',
                                            style: TextStyle(
                                                fontFamily: "Inria Serif",
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${comercical[index].propertyaddress}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Inria Serif",
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            "starting from ",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: "Inria Serif",
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${comercical[index].price} \$',
                                          style: TextStyle(
                                              fontFamily: "Inria Serif",
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
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
