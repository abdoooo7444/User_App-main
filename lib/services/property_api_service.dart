import 'dart:math';

import 'package:dio/dio.dart';
import 'package:project_second/models/properties.dart';

class ApiServices {
  late Dio dio;

  ApiServices() {
    dio = Dio(BaseOptions(
      baseUrl: "http://10.0.2.2:4000",
    ));
  }

  Future<List<Property>> getResidential() async {
    try {
      final Response<List<dynamic>> response =
          await dio.get('/api/properties/Res');
      List<Property> properties = [];
      if (response.data != null) {
        properties = response.data!
            .map((e) => Property.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return properties;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Property>> getallProperty() async {
    try {
      final Response<List<dynamic>> response = await dio.get('/api/properties');

      List<Property> properties = [];

      if (response.data != null) {
        properties = response.data!
            .map((e) => Property.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return properties;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Property>> getcommercials() async {
    try {
      final Response<List<dynamic>> response =
          await dio.get('/api/properties/Comm');
      List<Property> properties = [];

      if (response.data != null) {
        properties = response.data!
            .map((e) => Property.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return properties;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Property>> getSingleCommercialByQuery(String search) async {
    List<Property> prop = [];
    try {
      final Response response = await dio.get('/api/properties/Res/$search?');
      if (response.data != null) {
        prop =
            List<Property>.from(response.data.map((e) => Property.fromJson(e)));
      } else
        (error) {
          ; // Indicate no property found
        };
    } catch (e) {
      // rethrow;
    }
    return prop;
  }

  Future<Property?> getSingleResdentialByAddress(String search) async {
    try {
      final Response<Map<String, dynamic>> response = await dio.get(
        '/api/properties/Res/$search?', // Use "/Comm/$address" for commercial properties
      );

      if (response.data != null) {
        return Property.fromJson(response.data!);
      } else
        (error) {
          ; // Indicate no property found
        };
    } catch (e) {
      // rethrow;
    }
  }

  Future<Property?> getSingleCommercialByAddress(String search) async {
    try {
      final Response<Map<String, dynamic>> response = await dio.get(
        '/api /properties/Res/$search?', // Use "/Comm/$address" for commercial properties
      );

      if (response.data != null) {
        return Property.fromJson(response.data!);
      } else
        (error) {
// Indicate no property found
        };
    } catch (e) {
      // rethrow;
    }
  }

  // Future<Property?> getSinglePropertyByAddress(String propertyaddress) async {
  //   try {
  //     final Response<Map<String, dynamic>> response = await dio.get(
  //       '/api/properties$propertyaddress', // Use "/Comm/$address" for commercial properties
  //     );

  //     if (response.data != null) {
  //       return Property.fromJson(response.data!);
  //     } else
  //       (error) {
  //         ; // Indicate no property found
  //       };
  //   } catch (e) {
  //     // rethrow;
  //   }
  // }

  // Future<Property?> addNewResdential(Property property) async {
  //   try {
  //     final response =
  //         await dio.post('/api/properties/Res', data: property.toJson());

  //     // if (response.data != null) {
  //     //   return Property.fromJson(response.data!);
  //     // }
  //     return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<Property?> addNewCommercial(Property property) async {
  //   try {
  //     final Response<Map<String, dynamic>> response =
  //         await dio.post('/api/properties/Comm', data: property.toJson());

  //     if (response.data != null) {
  //       return Property.fromJson(response.data!);
  //     }

  //     return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<Property?> deleteResidential(Property property) async {
  //   try {
  //     final Response<Map<String, dynamic>> response =
  //         await dio.delete('/api/properties/Res/${property.id}');

  //     if (response.data != null) {
  //       return Property.fromJson(response.data!);
  //     }

  //     return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<Property?> deleteCommercial(Property property) async {
  //   try {
  //     final response = await dio.delete('/api/properties/Comm/${property.id}');

  //     if (response.data != null) {
  //       return Property.fromJson(response.data!);
  //     }

  //     return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
