class Property {
  String? id;
  String? kind;
  String? status;
  String? type;
  String? image;
  String? propertyaddress;
  int? price;
  int? phoneNumber;
  String? moreDetails;
  String? rentDuration;
  double? latitude;
  double? longitude;
  String? color;
  int? v;

  Property({
    this.id,
    this.kind,
    this.status,
    this.type,
    this.color,
    this.propertyaddress,
    this.price,
    this.phoneNumber,
    this.moreDetails,
    this.rentDuration,
    this.image,
    this.longitude,
    this.latitude,
    this.v,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json['_id'] as String?,
        kind: json['kind'] as String?,
        status: json['status'] as String?,
        color: json['color'] as String?,
        type: json['type'] as String?,
        propertyaddress: json['propertyaddress'] as String?,
        price: json['price'] as int?,
        phoneNumber: json['phoneNumber'] as int?,
        moreDetails: json['moreDetails'] as String?,
        image: json['image'] as String?,
        rentDuration: json['rentDuration'] as String?,
        longitude: json['longitude'] as double?,
        latitude: json['latitude'] as double?,
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson(Property data) => {
        '_id': id,
//  'kind': kind,
        'type': type,
        'status': status,
        'propertyaddress': propertyaddress,
        'price': price,
        'phoneNumber': phoneNumber,
        'moreDetails': moreDetails,
        'color': color,
        'rentDuration': rentDuration,
        'image': image,
        'longitude': longitude,
        'latitude': latitude,
        '__v': v,
      };

  Map<String, dynamic> toMap() => {
        '_id': id,
        'kind': kind,
        'status': status,
        'type': type,
        'color': color,
        'propertyaddress': propertyaddress,
        'price': price,
        'phoneNumber': phoneNumber, // Corrected typo
        'moreDetails': moreDetails,
        'rentDuration': rentDuration,
        'image': image,
        'longitude': longitude,
        'latitude': latitude,
        '__v': v,
      };
}
