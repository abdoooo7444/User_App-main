
import 'package:flutter/material.dart';



class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SettingUI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _controllerUserName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  late Future<String> _dataFromDatabaseUserName;
  late Future<String> _dataFromDatabaseEmail;

  @override
  void initState() {
    super.initState();
    _dataFromDatabaseUserName = fetchDataFromDatabase('UserName');
    _dataFromDatabaseEmail = fetchDataFromDatabase('Email');
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration commonInputDecoration = InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.black),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.black),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(65, 73, 106, 1),
          ),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text(
              "Edit Profile",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            "assets/a80e3690318c08114011145fdcfa3ddb.jpg"),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        color: Color.fromRGBO(118, 165, 209, 1),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            MyEditableTextField(
              labelText: 'User Name',
              controller: _controllerUserName,
              fetchDataFromDatabase: () async {
                return await fetchDataFromDatabase('UserName');
              },
              inputDecoration: commonInputDecoration,
            ),
            const SizedBox(
              height: 40,
            ),
            MyEditableTextField(
              labelText: "Email",
              controller: _controllerEmail,
              fetchDataFromDatabase: () async {
                return await fetchDataFromDatabase("Email");
              },
              inputDecoration: commonInputDecoration,
            ),
            const SizedBox(
              height: 40,
            ),
            Text("Your Password",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 10),
              child: TextFormField(
                controller: _controllerPassword,
                obscureText: true,
                style: TextStyle(
                    fontWeight: FontWeight.bold), // Make password text bold
                decoration: commonInputDecoration.copyWith(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Current Password',
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 10),
              child: TextFormField(
                decoration: commonInputDecoration.copyWith(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'New Password',
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 10),
              child: TextFormField(
                decoration: commonInputDecoration.copyWith(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Confirm Password',
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // primary: Color.fromRGBO(118, 165, 209, 1),
              ),
              onPressed: () {
                // Add logic for saving changes
                print('Save button pressed');
              },
              child: Text(
                '   Save   ',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyEditableTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final Future<String> Function() fetchDataFromDatabase;
  final InputDecoration inputDecoration;

  MyEditableTextField({
    required this.labelText,
    required this.controller,
    required this.fetchDataFromDatabase,
    required this.inputDecoration,
  });

  @override
  _MyEditableTextFieldState createState() => _MyEditableTextFieldState();
}

class _MyEditableTextFieldState extends State<MyEditableTextField> {
  late Future<String> _dataFromDatabase;

  @override
  void initState() {
    super.initState();
    _dataFromDatabase = widget.fetchDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 16),
        FutureBuilder<String>(
          future: _dataFromDatabase,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              widget.controller.text = snapshot.data ?? '';
              return TextField(
                controller: widget.controller,
                enabled: true,
                onChanged: (value) {
                  // Handle user input
                },
                decoration: widget.inputDecoration,
              );
            }
          },
        ),
      ],
    );
  }
}

Future<String> fetchDataFromDatabase(String fieldName) async {
  // fetch from database
  await Future.delayed(Duration(seconds: 2));
  return 'Data for $fieldName';
}

