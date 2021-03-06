import 'package:central_borssa/constants/url.dart';
import 'package:central_borssa/data/model/GlobalAuction.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalAuctionRepository {
  Dio _dio = new Dio();
  Future<Either<String, Rates>> getGlobalAuction() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _token = _prefs.getString('token');

      _dio..options.headers['authorization'] = 'Bearer $_token';

      var response = await _dio.get(globalAuctionUrl);
      var status = response.data['status'];
      var allcurrency = Data.fromJson(response.data['data']);
      print('global auctions');
      print(allcurrency.rates.eUR);

      if (status == "success") {
        return Right(allcurrency.rates);
      } else {
        return Left("error");
      }
    } catch (e) {
      return Left("error");
    }
  }
}
