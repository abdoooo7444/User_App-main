class Offers {
  String? id;
  String? kind;
  String? username;
  String? email;

  String? status;
  String? type;
  String? image;
  String? propertyaddress;
  int? price;
  int? propPrice;
  String? phoneNumber;
  String? moreDetails;
  String? rentDuration;
  double? latitude;
  double? longitude;
  int? v;

  Offers({
    this.id,
    this.kind,
    this.email,
    this.username,
    this.propPrice,
    this.status,
    this.type,
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

  factory Offers.fromJson(Map<String, dynamic> json) => Offers(
        id: json['_id'] as String?,
        kind: json['kind'] as String?,
        username: json['username'] as String?,
        email: json['email'] as String?,
        status: json['status'] as String?,
        type: json['type'] as String?,
        propertyaddress: json['propertyaddress'] as String?,
        price: json['price'] as int?,
        propPrice: json['propPrice'] as int?,
        phoneNumber: json['phoneNumber'] as String?,
        moreDetails: json['moreDetails'] as String?,
        image: json['image'] as String?,
        rentDuration: json['rentDuration'] as String?,
        longitude: json['longitude'] as double?,
        latitude: json['latitude'] as double?,
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
//  'kind': kind,
        'type': type,
        'status': status,
        'username': username,
        'propPrice': propPrice,
        'email': email,
        'propertyaddress': propertyaddress,
        'price': price,
        'phoneNumber': phoneNumber,
        'moreDetails': moreDetails,
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
        'propPrice': propPrice,
        'type': type,
        'propertyaddress': propertyaddress,
        'price': price,
        'phoneNumber': phoneNumber,
        'moreDetails': moreDetails,
        'rentDuration': rentDuration,
        'image': image,
        'longitude': longitude,
        'latitude': latitude,
        '__v': v,
      };
}
