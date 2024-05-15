// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:project_second/Pages/show_page.dart';
import 'package:project_second/models/properties.dart';
import 'package:project_second/services/favourite_api_service.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final TextEditingController _searchController = TextEditingController();
  String _searchAddress = '';
  List<Property> favourites = [];
  bool isloading = true;

  @override
  void initState() {
    getFavourite();
    searchProperty();
    super.initState();
  }

  Future<void> getFavourite() async {
    try {
      final data = await favouriteApiServices().getfavourite();
      setState(() {
        isloading = true;
      });

      favourites = data;
      print("============================================");
      print(favourites[0].status);
      print(favourites[0].longitude);
      print("============================================");
      setState(() {
        isloading = false;
      });
    } catch (e) {}
  }

  Future<void> searchProperty() async {
    setState(() {
      isloading = true;
    });
    try {
      Property favourite = Property(
          propertyaddress: _searchAddress, price: int.parse(_searchAddress));

      Property? singleFavourite =
          await favouriteApiServices().getSingleFavourite(favourite);
      if (singleFavourite != null) {
        setState(() {
          favourites = [singleFavourite];
          isloading = false;
        });
      } else {
        setState(() {
          favourites = [];
          isloading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to find the property you want.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      setState(() {
        favourites = [];
        isloading = false;
      });

      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: const Text('Error'),
      //       content: const Text('Failed to fetch data from server.'),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: const Text('OK'),
      //         ),
      //       ],
      //     );
      //   },
      // );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
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
                      Navigator.pop(context);
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
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by Address or price ',
                      hintStyle: TextStyle(
                        fontFamily: "Inria Serif",
                      ),
                      icon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchAddress = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SingleProperty(
                                  data: favourites[index].toMap()),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SingleProperty(
                                          data: favourites[index].toMap()),
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Remove from favorites",
                                          style: TextStyle(
                                            fontFamily: "Inria Serif",
                                          ),
                                        ),
                                        content: const Text(
                                          "Are you sure you want to remove from favorites?",
                                          style: TextStyle(
                                            fontFamily: "Inria Serif",
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                fontFamily: "Inria Serif",
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Navigator.pop(context);
                                              // deleteFavourite(
                                              //     " ${favourites[index]['documentId']}",
                                              //     index);
                                            },
                                            child: const Text(
                                              "Remove",
                                              style: TextStyle(
                                                fontFamily: "Inria Serif",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ); // This was missing
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      // height: 100,
                                      padding: const EdgeInsets.all(20),
                                      width: double.infinity,
                                      color: Colors.grey[200],
                                      child:
                                          //  Image.network(
                                          //     // '${favourites[index].image}',
                                          //     // height: 225,
                                          //     // fit: BoxFit.fill,
                                          //     ),
                                          Text(
                                        '${favourites[index].type}'
                                        '${favourites[index].latitude}'
                                        '${favourites[index].longitude}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            fontFamily: "Inria Serif"),
                                      ),
                                    ),
                                  ],
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
