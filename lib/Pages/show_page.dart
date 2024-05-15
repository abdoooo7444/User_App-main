// ignore_for_file: use_build_context_synchronously, avoid_print, missing_required_param, deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_second/Pages/home_page.dart';
import 'package:project_second/Pages/tour_request_page.dart';
import 'package:project_second/models/offers_model.dart';
import 'package:project_second/models/properties.dart';
import 'package:project_second/services/favourite_api_service.dart';
import 'package:project_second/services/offer_api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class SingleProperty extends StatefulWidget {
  final Map<String, dynamic> data;

  const SingleProperty({super.key, this.data = const {}});
  @override
  State<SingleProperty> createState() => _CCState();
}

GlobalKey<ScaffoldState> _ss = GlobalKey();
final rentController = TextEditingController();
final nameController = TextEditingController();
final mailController = TextEditingController();
final numberController = TextEditingController();

///

bool isFavorite = false;

///
// GoogleMapController? gmc;

///
StreamSubscription<Position>? positionStream;

// List<Marker> marker = [
//   // Marker(markerId: MarkerId("1"), position: LatLng(26.559074, 31.695669))
// ];
// CameraPosition camera = CameraPosition(
//   target: LatLng(26.559074, 31.695669),
//   zoom: 14.4746,
// );

class _CCState extends State<SingleProperty> {
  initialstreem() async {
    LocationPermission permission;
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled == false) {
      print("Servcies location is not enabled ");
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("location permmision is denid");
      }
    }
    if (permission == LocationPermission.whileInUse) {
      positionStream =
          Geolocator.getPositionStream().listen((Position? position) {
        // marker.add(Marker(
        // markerId: MarkerId("1"),
        // position: LatLng(position!.latitude, position!.longitude)));
        // gmc!.animateCamera(CameraUpdate.newLatLng(
        //     LatLng(position!.latitude, position!.longitude)));
        setState(() {});
      });
    }
  }

  final OfferApiServices offerapiServices = OfferApiServices();

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream!.cancel();
    }
    super.dispose();
  }

  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();

  @override
  void initState() {
    //getCurrentlocation();
    //initialstreem();
    checkFavoriteStatus();
    super.initState();
  }

  Future<bool> checkFavoriteStatus() async {
    try {
      final Favorite = await favouriteApiServices().checkIfFavourite(favourite);
      return isFavorite = true;
    } catch (e) {
      print('Error checking favorite status: $e');
      return false; // Default to not favorite if there's an error
    }
  }

  void launchWhatsapp({@required number, @required message}) async {
    String whatsAppURL = "whatsapp://send?+2001211406202";
    launchUrl(Uri.parse(whatsAppURL));
  }

  launchPhoneDialer(String phoneNumber) async {
    String url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchUrl(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }

  bool isFavorite = false;
  Property favourite = Property();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      key: _ss,
      appBar: AppBar(
        leading: const BackButton(
          color: Color.fromRGBO(118, 165, 209, 1),
          // Adjust the size as needed
        ),
        //  backgroundColor: Colors.white,
      ),
      body: Column(
        //mainAxisAlignment:MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.grey[200],
            // child: Image.network(
            //   '${widget.data['image']}',
            //   height: 150,
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            // ),
          ),
          GestureDetector(
            onTap: () async {
              try {
                if (!isFavorite) {
                  favourite = Property.fromJson(
                    widget.data,
                  );
                  //               favourite = Property.fromJson({
                  //   ...widget.data,
                  //   'color': color,
                  // });
                  // The property is not in favorites, so add it
                  favouriteApiServices().addtoFavourite(favourite);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Favorite Added Successfully'),
                    ),
                  );
                } else {
                  // The property is already in favorites
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Removed Successfully'),
                    ),
                  );
                }

                setState(() {
                  isFavorite = !isFavorite; // Toggle the favorite status
                });
              } catch (e) {
                print('Error adding/checking data : $e');
              }
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 40, top: 16),
                child: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  size: 40,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(
            // color: const Color.fromARGB(255, 184, 171, 171),
            height: 200,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "A ${widget.data['type']} for ${widget.data['status']} in ${widget.data['propertyaddress']}   \n ${widget.data['moreDetails']} \n the ${widget.data['status']} price is: ${widget.data['price']} \$ \n is empty for ${widget.data['rentDuration']} Months ",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inria Serif"),
              ),
            ),
          ),
          const SizedBox(
            height: 150,
            child: Column(
              children: [
                // Expanded(
                //   child: GoogleMap(
                //     onTap: (LatLng latLng) {
                //       marker.add(Marker(
                //           markerId: MarkerId("1"),
                //           position: LatLng(latLng.latitude, latLng.longitude)));

                //       setState(() {});
                //     },
                //     initialCameraPosition: camera,
                //     mapType: MapType.normal,
                //     markers: marker.toSet(),
                //     onMapCreated: (mapcontroller) {
                //       gmc = mapcontroller;
                //     },
                //   ),
                // )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(
                    fontSize: 15,
                  ),
                  side: const BorderSide(width: 0, color: Colors.white),
                  backgroundColor: const Color.fromRGBO(118, 165, 209, 1),
                ),
                onPressed: () {
                  _ss.currentState!.showBottomSheet(
                    (context) => SingleChildScrollView(
                      child: SizedBox(
                        height: 600,
                        width: double.infinity,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                "Make Offer",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Inria Serif",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      applyDiscount(5);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: .1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: const Color(0xffEEF1F6),
                                      ),
                                      height: 40,
                                      width: 125,
                                      child: const Center(
                                        child: Text(
                                          " -5%",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                              fontFamily: "Inria Serif"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    applyDiscount(10);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: .1,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: const Color(0xffEEF1F6),
                                    ),
                                    height: 40,
                                    width: 125,
                                    child: const Center(
                                      child: Text(
                                        "-10%",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontFamily: "Inria Serif"),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      applyDiscount(15);
                                      '${widget.data['price']}';
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: .1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: const Color(0xffEEF1F6),
                                      ),
                                      height: 40,
                                      width: 125,
                                      child: const Center(
                                        child: Text(
                                          " -15%",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                              fontFamily: "Inria Serif"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "${widget.data['status']} you want",
                                  style: const TextStyle(
                                      fontSize: 18, fontFamily: "Inria Serif"),
                                ),
                              ),
                            ),
                            /////////////////////////////

                            SizedBox(
                              width: 400,
                              child: TextFormField(
                                controller: rentController,
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(
                                      fontFamily: "Inria Serif"),
                                  labelText: '${widget.data['price']}',
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 123, 24, 24),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  "Enter your Name",
                                  style: TextStyle(
                                      fontSize: 18, fontFamily: "Inria Serif"),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 400,
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  "Enter your Email",
                                  style: TextStyle(
                                      fontSize: 18, fontFamily: "Inria Serif"),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 400,
                              child: TextFormField(
                                controller: mailController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  "Enter your number",
                                  style: TextStyle(
                                      fontSize: 18, fontFamily: "Inria Serif"),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 400,
                              child: TextFormField(
                                controller: numberController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Spacer(
                                  flex: 1,
                                ),

                                /////////////////////////////////////make offer///////////////////////////////
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      final offer = Offers(
                                        type: widget.data['type'],
                                        propertyaddress:
                                            widget.data['propertyaddress'],
                                        username: nameController.text,
                                        email: mailController.text,
                                        // price: int.parse(widget.data['price']),
                                        phoneNumber: numberController
                                            .text, // Improved error handling
                                        moreDetails: widget.data['type'],
                                        rentDuration:
                                            widget.data['rentDuration'],
                                        propPrice:
                                            int.tryParse(rentController.text),
                                        image: widget.data['image'],
                                        // latitude: double.tryParse(widget.data[
                                        // 'latitude']), // More robust parsing
                                        // longitude: double.tryParse(widget.data[
                                        // 'longitude']
                                        // ), // More robust parsing
                                      );

                                      final addedOffer = await offerapiServices
                                          .addNewoffer(offer);

                                      if (addedOffer != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.green,
                                            content:
                                                Text('Data Added Successfully'),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                'Failed to add property. Please try again.'),
                                          ),
                                        );
                                      }
                                    } on FormatException catch (e) {
                                      // Handle parsing errors (e.g., invalid number format)
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              'Invalid data format. Please check your input.'),
                                        ),
                                      );
                                      print('Error parsing data: $e');
                                    } catch (e) {
                                      // Handle other unexpected errors
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              'An error occurred. Please try again later.'),
                                        ),
                                      );
                                      print('Error adding data: $e');
                                    }
                                  },
                                  child: const Text("Add Property"),
                                ),
                                const Spacer(
                                  flex: 1,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Inria Serif",
                                    ),
                                  ),
                                ),

                                const Spacer(
                                  flex: 1,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.local_offer_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  "Make Offer ",
                  style: TextStyle(fontFamily: "Inria Serif"),
                ),
              ),
              OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 15,
                  ),
                  // onPrimary: Colors.black,
                  side: const BorderSide(width: 0, color: Colors.white),
                  backgroundColor: const Color.fromRGBO(118, 165, 209, 1),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourRequestPage(
                          request: widget.data,
                        ),
                      ));
                },
                icon: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  " Tour Request ",
                  style: TextStyle(fontFamily: "Inria Serif"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 19),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  launchWhatsapp();
                },
                child: Image.asset(
                  'Assets/whatsapp.png',
                  height: 46.5,
                  width: 50,
                ),
              ),
              InkWell(
                onTap: () {
                  launchPhoneDialer('${widget.data['phoneNumber']}');
                },
                child: Image.asset(
                  'Assets/44.jpg',
                  height: 50,
                  width: 50,
                ),
              ),
            ],
          ),
        ],
      ),
      //   ),
      // ),
    );
  }

  void applyDiscount(double discountPercentage) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection(
              'ResidentialProperty') // Replace with your actual collection name
          .doc(
              '${widget.data['propertyPrice']}') // Use widget.data['ss'] as the document ID
          .get();

      Map<String, dynamic> data = snapshot.data() ?? {};
      double originalPrice = (data['propertyPrice'] ?? 0).toDouble();

      double discountedPrice =
          originalPrice - (originalPrice * (discountPercentage / 100));

      // Show an AlertDialog with the discounted price
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discounted Price'),
          content:
              Text('Discounted Price: \$${discountedPrice.toStringAsFixed(2)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      print('Error applying discount: $error');
    }
  }
}

// void ShowSnackBar(BuildContext context, String message, Color color) {
//   final snackBar = SnackBar(
//     content: Text(message),
//     backgroundColor: Colors.green, // Set the background color here
//   );

//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
