import 'package:dio/dio.dart';
import 'package:project_second/models/properties.dart';
import 'package:project_second/models/tour_req_model.dart';

class tourApiServices {
  late final Dio dio;

  tourApiServices() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://10.0.2.2:4000",
      ),
    );
  }

  Future<TourRequest?> addNewTour(TourRequest request) async {
    try {
      final Response<Map<String, dynamic>> response =
          await dio.post('/api/tours', data: request.toJson());

      if (response.data != null) {
        return TourRequest.fromJson(response.data!);
      } else {
        throw Exception('Failed to create new tour request');
      }
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      print('Error adding new tour request: ${e.type}, ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }

  Future<TourRequest?> updateTour(
      String tourId, TourRequest updatedRequest) async {
    try {
      final Response<Map<String, dynamic>> response =
          await dio.put('/api/tours/$tourId', data: updatedRequest.toJson());

      if (response.data != null) {
        return TourRequest.fromJson(response.data!);
      } else {
        throw Exception('Failed to update tour request');
      }
    } on DioError catch (e) {
      print('Error updating tour request: ${e.type}, ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }
}
