import 'package:central_borssa/constants/url.dart';
import 'package:central_borssa/data/model/Currency.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:central_borssa/data/model/Post/Cities.dart';

class CityRepository {
  Dio _dio = new Dio();
  late List<CurrencyPrice> mycities = [];
  late List<City> city = [];

  Future<Either<String, List<CurrencyPrice>>> allCity() async {
    mycities.clear();

    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _token = _prefs.getString('token');

      _dio..options.headers['authorization'] = 'Bearer $_token';

      var response = await _dio.get(currencyUpdateUrl);
      var status = response.data['status'];
      var allcurrency = Data.fromJson(response.data['data']);

      allcurrency.currencyPrice.forEach((v) {
        mycities.add(v);
      });
      if (status == "success") {
        return Right(mycities);
      } else {
        return Left("error");
      }
    } catch (e) {
      return Left("error");
    }
  }

  Future<Either<String, List<list>>> allCityName() async {
    mycities.clear();

    // try {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.getString('token');

    _dio.options.headers['authorization'] = 'Bearer $_token';

    var response = await _dio.get(allCities);
    var status = response.data['status'];
    var test = data.fromJson(response.data['data']);

    if (status == "success") {
      return Right(test.lists);
    } else {
      return Left("error");
    }
    // } catch (e) {
    //   return Left("error");
    // }
  }
}
