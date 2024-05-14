import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_second/Pages/show_page.dart';

class ShowProperty extends StatefulWidget {
  const ShowProperty({super.key});

  @override
  State<ShowProperty> createState() => _ShowPropertyState();
}

class _ShowPropertyState extends State<ShowProperty> {
  List commercial = [];
  List residential = [];
  bool isLoading = false;
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
      body: isLoading == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: isResidential ? residential.length : commercial.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Card(
                            color: Colors.white,
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: (){
                                     isResidential ?    Navigator.push(context, MaterialPageRoute(builder: (context) =>SingleProperty( data: residential[index],) ,)) : 
                               Navigator.push(context, MaterialPageRoute(builder: (context) =>SingleProperty(data: commercial[index],) ,)) ;  
                                },
                                child: Container(
                                  width: 200,
                                  height: 300,
                                  child: Image.network(
                                    isResidential
                                        ? '${residential[index]['image']}'
                                        : '${commercial[index]['image']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                isResidential
                                    ? '${residential[index]['propertyType']}'
                                    : '${commercial[index]['propertyType']}',
                              ),
                              subtitle: Text(
                                isResidential
                                    ? '${residential[index]['propertyStatus']} \n ${residential[index]['propertyAdress']} \n ${residential[index]['propertyDetails']} \n${residential[index]['propertyRentDuration']}'
                                    : '${commercial[index]['propertyStatus']} \n ${commercial[index]['propertyAdress']} \n ${commercial[index]['propertyDetails']} \n ${commercial[index]['propertyRentDuration']}',
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
                                 isResidential ?    Navigator.push(context, MaterialPageRoute(builder: (context) =>SingleProperty( data: residential[index],) ,)) : 
                               Navigator.push(context, MaterialPageRoute(builder: (context) =>SingleProperty(data: commercial[index],) ,)) ;   },
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
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
                        child: const Text('Residential', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> getCommercial() async {
    final CollectionReference tblProduct = FirebaseFirestore.instance.collection('commercialProperty');
    await tblProduct.get().then((querySnapshot) {
      for (final doc in querySnapshot.docs) {
        final Map<String, dynamic> store = doc.data()! as Map<String, dynamic>;
        store['documentId'] = doc.id;
        commercial.add(store);
      }
    });
    setState(() {
      isLoading = true;
    });
  }

  Future<void> getResidential() async {
    final CollectionReference tblProduct = FirebaseFirestore.instance.collection('ResidentialProperty');
    await tblProduct.get().then((querySnapshot) {
      for (final doc in querySnapshot.docs) {
        final Map<String, dynamic> store = doc.data()! as Map<String, dynamic>;
        store['documentId'] = doc.id;
        residential.add(store);
      }
    });

    setState(() {
      isLoading = true;
    });
  }
}
