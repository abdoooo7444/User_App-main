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
          await dio.get('/api/properties/Comm');

      print("===========================================");
      print(response.data);
      print("===========================================");
      List<Property> properties = [];

      if (response.data != null) {
        properties = response.data!
            .map((e) => Property.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return properties;
    } catch (e) {
      print('Error retrieving residential data: $e');
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
      print('Error retrieving residential data: $e');
      rethrow;
    }
  }

  Future<List<Property>> getcommercials() async {
    try {
      final Response<List<dynamic>> response =
          await dio.get('/api/properties/Comm');
      print("====================ccccccccc=======================");
      print(response.data);
      print("=============================cccccccc==============");
      List<Property> properties = [];

      if (response.data != null) {
        properties = response.data!
            .map((e) => Property.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return properties;
    } catch (e) {
      print('Error retrieving residential data: $e');
      rethrow;
    }
  }

  Future<Property?> getSingleCommercialByQuery(String search) async {
    try {
      final Response<Map<String, dynamic>> response = await dio.get(
        '/api/properties//$search?', // Use "/Comm/$address" for commercial properties
      );

      if (response.data != null) {
        return Property.fromJson(response.data!);
      } else
        (error) {
          print(error);
          print("=============response.data=============");
          ; // Indicate no property found
        };
    } catch (e) {
      print('Error retrieving commercial property by address: $e');
      // rethrow;
    }
  }

  Future<Property?> getSingleResdentialByAddress(String search) async {
    try {
      final Response<Map<String, dynamic>> response = await dio.get(
        '/api/properties/Comm/$search?', // Use "/Comm/$address" for commercial properties
      );

      if (response.data != null) {
        return Property.fromJson(response.data!);
        print("=============response.data=============");
        print(response);
        print("=============response.data=============");
      } else
        (error) {
          print(error);
          print("=============response.data=============");
          ; // Indicate no property found
        };
    } catch (e) {
      print('Error retrieving commercial property by address: $e');
      // rethrow;
    }
  }

  Future<Property?> getSingleCommercialByAddress(String search) async {
    try {
      final Response<Map<String, dynamic>> response = await dio.get(
        '/api/properties/Comm/$search?', // Use "/Comm/$address" for commercial properties
      );

      if (response.data != null) {
        return Property.fromJson(response.data!);
        print("=============response.data=============");
        print(response);
        print("=============response.data=============");
      } else
        (error) {
          print(error);
          print("=============response.data=============");
          ; // Indicate no property found
        };
    } catch (e) {
      print('Error retrieving commercial property by address: $e');
      // rethrow;
    }
  }

  Future<Property?> getSinglePropertyByAddress(String propertyaddress) async {
    try {
      final Response<Map<String, dynamic>> response = await dio.get(
        '/api/properties$propertyaddress', // Use "/Comm/$address" for commercial properties
      );

      if (response.data != null) {
        return Property.fromJson(response.data!);
        print("=============response.data=============");
        print(response);
        print("=============response.data=============");
      } else
        (error) {
          print(error);
          print("=============response.data=============");
          ; // Indicate no property found
        };
    } catch (e) {
      print('Error retrieving commercial property by address: $e');
      // rethrow;
    }
  }

  Future<Property?> addNewResdential(Property property) async {
    try {
      final Response<Map<String, dynamic>> response =
          await dio.post('/api/properties/Res', data: property.toJson());

      if (response.data != null) {
        return Property.fromJson(response.data!);
      }

      return null;
    } catch (e) {
      print('Error adding new residential property: $e');
      return null;
    }
  }

  Future<Property?> addNewCommercial(Property property) async {
    try {
      final Response<Map<String, dynamic>> response =
          await dio.post('/api/properties/Comm', data: property.toJson());

      if (response.data != null) {
        return Property.fromJson(response.data!);
      }

      return null;
    } catch (e) {
      print('Error adding new residential property: $e');
      return null;
    }
  }

  Future<Property?> deleteResidential(Property property) async {
    try {
      final Response<Map<String, dynamic>> response =
          await dio.delete('/api/properties/Res/${property.id}');

      if (response.data != null) {
        return Property.fromJson(response.data!);
      }

      return null;
    } catch (e) {
      print('Error deleting residential property: $e');
      return null;
    }
  }

  Future<Property?> deleteCommercial(Property property) async {
    try {
      final Response<Map<String, dynamic>> response =
          await dio.delete('/api/properties/Comm/${property.id}');

      if (response.data != null) {
        return Property.fromJson(response.data!);
      }

      return null;
    } catch (e) {
      print('Error deleting residential property: $e');
      return null;
    }
  }
}
