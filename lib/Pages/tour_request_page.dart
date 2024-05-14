import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_second/models/tour_req_model.dart';
import 'package:project_second/services/tour_request_api_servise.dart';
import 'package:table_calendar/table_calendar.dart';

class TourRequestPage extends StatefulWidget {
  TourRequestPage({Key? key, required this.request}) : super(key: key);

  final Map<String, dynamic> request;

  @override
  State<TourRequestPage> createState() => _TourRequestPageState();
}

final selectedTourTimeController = TextEditingController();

class _TourRequestPageState extends State<TourRequestPage> {
  DateTime today = DateTime.now();
  String selectedTourTime = '';
  DateTime selectedDay = DateTime.now(); // Initialize with the current date
  ValueNotifier<bool> isVirtualSelected = ValueNotifier<bool>(false);
  String pervertula = "";

  @override
  Widget build(BuildContext context) {
    void _handleTourTimeChange(String value) {
      setState(() {
        selectedTourTime = value;
      });
    }

    void _handleInPersonTap() {
      setState(() {
        isVirtualSelected.value = false;
        pervertula = "person";
      });
    }

    void _handleVirtualTap() {
      setState(() {
        isVirtualSelected.value = true;
        pervertula = "virtual";
      });
    }

    void _handleSubmit() async {
      try {
        TourRequest request = TourRequest(
          type: pervertula,
          date: selectedDay,
          selectedTourTime: selectedTourTime,
          image: widget.request['image'],
          latitude: widget.request['latitude'],
          longitude: widget.request['longitude'],
          propertyAddress: widget.request['propertyaddress'],
          phoneNumber: widget.request['phoneNumber'],
          propertyDetails: widget.request['moreDetails'],
          // propertyPrice: widget.request['price'],
          rentDuration: widget.request['rentDuration'],
          propertyStatus: widget.request['propertyStatus'],
        );

        await tourApiServices().addNewTour(request);
        const snackBar = SnackBar(
          content: Text('TOUR REQUEST DONE'),
        );
        setState(() {});
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
        }
      } on DioException catch (e) {
        if (e.response?.data != null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.response!.data['message'])),
            );
          }
        } else {
          print('DioException occurred: ${e.message}');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('DioException occurred')),
            );
          }
        }
      } catch (e, stackTrace) {
        print('Unexpected error: $e, $stackTrace');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unexpected error occurred')),
          );
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                onPressed: () => Navigator.pop(context), // Navigate back
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Tour Request',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 33,
                color: Color.fromRGBO(65, 73, 106, 1),
                fontFamily: "Inria Serif",
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _handleInPersonTap,
                  child: Container(
                    height: 50,
                    width: 160,
                    decoration: BoxDecoration(
                      color: isVirtualSelected.value
                          ? Colors.grey
                          : Colors.blue[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'In person',
                        style: TextStyle(
                          fontFamily: "Inria Serif",
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                GestureDetector(
                  onTap: _handleVirtualTap,
                  child: Container(
                    height: 50,
                    width: 160,
                    decoration: BoxDecoration(
                      color: isVirtualSelected.value
                          ? Colors.blue[600]
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Virtual',
                        style: TextStyle(
                          fontFamily: "Inria Serif",
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.calendar_month),
                ),
                Text(
                  ' Select tour date',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: "Inria Serif"),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.blue[600]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: TableCalendar(
                  locale: 'en_us',
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  rowHeight: 35,
                  selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                  focusedDay: today,
                  firstDay: today,
                  lastDay: DateTime.utc(2030, 01, 01),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDay = selected;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.access_time),
                ),
                Text(
                  ' Select tour time',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: "Inria Serif"),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                Radio(
                  value: '12:00 PM',
                  groupValue: selectedTourTime,
                  onChanged: (value) => _handleTourTimeChange(value as String),
                ),
                const Text(
                  '12:00 PM',
                  style: TextStyle(fontFamily: "Inria Serif"),
                ),
                const SizedBox(width: 20),
                Radio(
                  value: '11:00 AM',
                  groupValue: selectedTourTime,
                  onChanged: (value) => _handleTourTimeChange(value as String),
                ),
                const Text('11:00 AM',
                    style: TextStyle(fontFamily: "Inria Serif")),
                const SizedBox(width: 20),
                Radio(
                  value: '7:00 PM',
                  groupValue: selectedTourTime,
                  onChanged: (value) => _handleTourTimeChange(value as String),
                ),
                const Text('7:00 PM',
                    style: TextStyle(fontFamily: "Inria Serif")),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Submit Request',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: "Inria Serif"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
