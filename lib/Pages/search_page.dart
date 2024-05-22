import 'package:flutter/material.dart';
import 'package:project_second/Pages/show_page.dart';
import 'package:project_second/models/properties.dart';

class search extends SearchDelegate {
  final List<Property> property;
  List<Property> filter = [];

  search(
      {super.searchFieldLabel,
      super.searchFieldStyle,
      super.searchFieldDecorationTheme,
      super.keyboardType,
      super.textInputAction,
      required this.property});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.heart_broken))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    } else {
      filter.clear();
      for (var prop in property) {
        if (prop.price == int.parse(query)) {
          filter.add(prop);
        }
      }

      return ListView.builder(
        itemCount: filter.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleProperty(data: filter[index]),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
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
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                '${filter[index].type}',
                                style: const TextStyle(
                                    fontFamily: "Inria Serif",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              '${filter[index].propertyaddress}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: "Inria Serif",
                              ),
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
                                  fontFamily: "Inria Serif",
                                ),
                              ),
                            ),
                            Text(
                              '${filter[index].price} \$',
                              style: const TextStyle(
                                  fontFamily: "Inria Serif",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 13, 71, 119)),
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
      );
    }
  }
}
