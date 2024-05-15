import 'package:dio/dio.dart';
import 'package:project_second/models/offers_model.dart';

class OfferApiServices {
  late final Dio dio;

  OfferApiServices() : super() {
    // Call super constructor
    dio = Dio(
      BaseOptions(
        baseUrl: "http://10.0.2.2:4000",
      ),
    );
  }

  Future<Offers?> addNewoffer(Offers offer) async {
    try {
      final Response<Map<String, dynamic>> response =
          await dio.post('/api/offers', data: offer.toJson());

      if (response.data != null) {
        return Offers.fromJson(response.data!);
      }

      return null;
    } catch (e) {
      print('Error adding new offer property: $e');
      return null;
    }
  }
}
