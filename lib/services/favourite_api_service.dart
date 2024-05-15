import 'package:dio/dio.dart';
import 'package:project_second/models/properties.dart';

class favouriteApiServices {
  late Dio dio;

  favouriteApiServices() {
    dio = Dio(BaseOptions(
      baseUrl: "http://10.0.2.2:4000",
    ));
  }

  Future<Property?> addtoFavourite(Property favourite) async {
    try {
      final Response<Map<String, dynamic>> response =
          await dio.post('/api/favourites', data: favourite.toJson());

      if (response.data != null) {
        return Property.fromJson(response.data!);
      }

      return null;
    } catch (e) {
      print('Error adding to favourite: $e');
      return null;
    }
  }

  Future<Property?> getSingleFavourite(Property favourite) async {
    try {
      Response response =
          await dio.get('/api/favourites/${favourite.propertyaddress}');
      response = await dio.get('/api/favourites/${favourite.price}');
      print(response.data);
    } catch (e) {
      print('Error getting single favourite: $e');
    }
  }

  Future<List<Property>> getfavourite() async {
    try {
      final Response<List<dynamic>> response = await dio.get('/api/favourites');
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

  Future<Property?> removeFromFavourite(Property favourite) async {
    try {
      final Response<Map<String, dynamic>> response =
          await dio.delete('/api/favourites${favourite.id}');

      if (response.data != null) {
        return Property.fromJson(response.data!);
      }

      return null;
    } catch (e) {
      print('Error deleting favourite property: $e');
      return null;
    }
  }

  Future<bool> checkIfFavourite(Property favourite) async {
    try {
      final response = await dio.get(
        '/api/favorites${favourite.id}', // Replace with your actual endpoint
      );
      return response.statusCode ==
          200; // Property is a favorite if status code is 200
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        return false; // Property is not a favorite if status code is 404
      }
      print('Error checking favorite status: ${e.message}');
      return false; // Default to not favorite for other errors
    } catch (e) {
      print('Unexpected error checking favorite status: $e');
      return false; // Default to not favorite for unexpected errors
    }
  }
}
