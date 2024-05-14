class TourRequest {
  String? id;
  String? type;
  DateTime? date;
  String? selectedTourTime;
  String? image;
  String? propertyStatus;
  String? propertyAddress;
  String? propertyDetails;
  // String? propertyPrice;
  String? rentDuration;
  double? latitude;
  double? longitude;
  // String? email;
  int? phoneNumber;

  TourRequest({
    this.id,
    this.type,
    this.date,
    this.selectedTourTime,
    this.image,
    this.propertyStatus,
    this.propertyAddress,
    this.propertyDetails,
    // this.propertyPrice,
    this.rentDuration,
    this.longitude,
    this.latitude,
    // this.email,
    this.phoneNumber,
  });
  factory TourRequest.fromJson(Map<String, dynamic> json) => TourRequest(
        id: json['_id'] as String?,
        type: json['type'] as String?,
        date: DateTime.tryParse(json['date'] as String),
        selectedTourTime: json['selectedTourTime'] as String?,
        image: json['image'] as String?,
        propertyStatus: json['propertyStatus'] != null
            ? json['propertyStatus'] as String
            : null, // Check for null value
        propertyAddress: json['propertyaddress'] as String?,
        propertyDetails: json['propertyDetails'] as String?,
        ////// make Stirng
        // propertyPrice: json['propertyPrice'] as String,
        rentDuration: json['rentDuration'] as String?,
        longitude: json['longitude'] as double?,
        latitude: json['latitude'] as double?,
        // email: json['email'] as String,
        phoneNumber: json['phoneNumber'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'type': type,
        'date': date?.toIso8601String(),
        'selectedTourTime': selectedTourTime,
        'image': image,
        'propertyStatus': propertyStatus,
        'propertyAddress': propertyAddress,
        'propertyDetails': propertyDetails,
        // 'propertyPrice': propertyPrice,
        'rentDuration': rentDuration,
        'longitude': longitude,
        'latitude': latitude,
        // 'email': email,
        'phoneNumber': phoneNumber,
      };
}
