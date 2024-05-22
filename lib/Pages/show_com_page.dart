import 'package:flutter/material.dart';
import 'package:project_second/Pages/home_page.dart';
import 'package:project_second/Pages/search_page.dart';
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
      comercical = await ApiServices().getResidential();

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

  Future<List<Property>> _searchCommercialProperty(String address) async {
    try {
      List<Property> data =
          (await ApiServices().getSingleCommercialByQuery(address));
      if (data != null) {
        return data;
      } else {
        return data;
      }
    } catch (error) {
      print("Error fetching commercial property: $error");
      throw ('Undefined Error');
    }
  }

  void _handleSearchButtonPressed() async {
    String searchparama = _addressController.text.trim();
    if (searchparama.isEmpty) {
      print("Please enter an query to search.");
      return; // Exit early if address is empty
    }

    try {
      List<Property>? property = await _searchCommercialProperty(searchparama);
      if (property != null) {
        comercical.clear();
        comercical.addAll(property);
        setState(() {});
        print("Found commercial property: ${property.length}");
      } else {
        print("No commercial property found at $searchparama");
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
                  margin: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            _handleSearchButtonPressed();
                          },
                          onTap: () => showSearch(
                              delegate: search(property: comercical),
                              context: context),
                          controller: _addressController,
                          decoration: const InputDecoration(
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
                        icon: const Icon(Icons.check),
                        onPressed: _handleSearchButtonPressed,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: comercical.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SingleProperty(data: comercical[index]),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: Image.asset(
                                  'images/download.jpg',
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                // Image.network(
                                //   '${comercical[index].image}',
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
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              '${comercical[index].type}',
                                              style: const TextStyle(
                                                  fontFamily: "Inria Serif",
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            '${comercical[index].propertyaddress}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontFamily: "Inria Serif",
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "starting from ",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Inria Serif",
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${comercical[index].price} \$',
                                            style: const TextStyle(
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
