import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_second/Pages/contact_us.dart';
import 'package:project_second/Pages/edit_page.dart';
import 'package:project_second/Pages/favourite_page.dart';
import 'package:project_second/Pages/show_Res_page.dart';
import 'package:project_second/Pages/show_all_page.dart';
import 'package:project_second/Pages/show_com_page.dart';
import 'package:project_second/Pages/show_page.dart';
import 'package:project_second/models/properties.dart';
import 'package:project_second/services/property_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Map<String, dynamic>> Residential = [];
  List users = [];
  bool isloading = true;
  int currentIndex = 0;
  bool isselected = true;
  User? currentUser = FirebaseAuth.instance.currentUser;
  String? userName; // Added variable to store userName

  List<Property> Properties = [];
  List<Map<String, dynamic>> searchResults = [];

  void showAllProperty() async {
    try {
      setState(() {
        isloading = true;
      });
      Properties = await ApiServices().getallProperty();
      setState(() {
        isloading = false;
      });
    } catch (e) {
      print("=================");
      print(e);
      print("=================");
    }
  }

  void UserAccount() async {
    CollectionReference tblProduct =
        FirebaseFirestore.instance.collection('userAccount');
    await Future.delayed(const Duration(seconds: 2));
    await tblProduct.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> store = doc.data() as Map<String, dynamic>;

        store['documentId'] = doc.id;
        users.add(store);
      });

      if (users.isNotEmpty) {
        // Assuming there is only one user for the current implementation
        userName = users[0]['userName'];
      }

      setState(() {});
    });
  }

  // final TextEditingController _addressController = TextEditingController();

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

  void _handleSearchButtonPressed(value) async {
    String address = value.toString();
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
          'phoneNumber': property.phoneNumber,
          'price': property.price,
          'rentDuration': property.rentDuration,
          'type': property.type,
        };

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => SingleProperty(data: propertyMap),
        //   ),
        // );
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
    showAllProperty();
    UserAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop("LoginPage");
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      drawerEnableOpenDragGesture: false,
      drawerEdgeDragWidth: 0,
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName ?? 'N/A'), // Use userName here
              accountEmail: Text(currentUser?.email ?? 'N/A'),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('Assets/abdo.jpg'),
              ),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(118, 165, 209, 1),
              ),
            ),
            // SizedBox(height: 50),
            // ListTile(
            //   title: const Text('Edit your profile'),
            //   leading: Icon(Icons.edit),
            //   onTap: () {
            //     //  Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(),));
            //   },
            // ),
            ListTile(
              title: const Text(
                'Favorites',
                style: TextStyle(fontFamily: "Inria Serif"),
              ),
              leading: const Icon(Icons.favorite),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favorites()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Contact Us',
                style: TextStyle(fontFamily: "Inria Serif"),
              ),
              leading: const Icon(Icons.contact_support),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ContactUs()));
              },
            ),
            ListTile(
              title: const Text(
                'Log Out',
                style: TextStyle(fontFamily: "Inria Serif"),
              ),
              leading: const Icon(Icons.logout),
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("LoginPage", (route) => false);
              },
            ),
          ],
        ),
      ),
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Find your best ',
                      style: TextStyle(
                          color: Color.fromRGBO(56, 73, 106, 1),
                          fontSize: 30,
                          fontFamily: "Inria Serif",
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Property ',
                      style: TextStyle(
                          color: Color.fromRGBO(56, 73, 106, 1),
                          fontSize: 30,
                          fontFamily: "Inria Serif",
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          _handleSearchButtonPressed(value);
                          // updateSearchResults(value);
                        },
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(fontFamily: "Inria Serif"),
                          filled: true,
                          fillColor: const Color.fromRGBO(213, 215, 219, 1),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(searchResults[index]['propertyType']),
                          // Add more details or customize ListTile as needed
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Categories ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: "Inria Serif"),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowResdential(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.house,
                              size: 40,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'Residential',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 12,
                                  fontFamily: "Inria Serif"),
                            ),
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                const Size(160.0, 60.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowCommercial(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.apartment,
                              size: 40,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'Commercial',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 12,
                                  fontFamily: "Inria Serif"),
                            ),
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                const Size(160.0, 60.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Featured Properties ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: "Inria Serif"),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            // primary: Colors.black,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ShowProperty(),
                                ));
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(fontFamily: "Inria Serif"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Properties.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SingleProperty(data: Properties[index]),
                                ),
                              );
                            },
                            child: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    width: 200,
                                    color: Colors.grey[200],
                                    child:
                                        // Image.network(
                                        //   '${Properties[index].image}',
                                        //   height: 100,
                                        //   width: double.infinity,
                                        //   fit: BoxFit.fill,
                                        // ),
                                        Image.asset(
                                      'images/download (1).jpg',
                                      height: 130,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            '${Properties[index].type}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                fontFamily: "Inria Serif"),
                                          ),
                                          Text(
                                            '${Properties[index].status}',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontFamily: "Inria Serif"),
                                          ),
                                          Text(
                                            '${Properties[index].price}  \$ ',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Inria Serif"),
                                          )
                                        ],
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
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Favourite',
            icon: Icon(Icons.favorite_outline_rounded),
            activeIcon: Icon(Icons.favorite),
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: isselected ? Colors.blue : Colors.white,
        unselectedItemColor: const Color.fromRGBO(65, 73, 106, 1),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Favorites()),
            );
          }
          setState(() {});
        },
      ),
    );
  }
}
