import 'package:central_borssa/constants/url.dart';
import 'package:central_borssa/data/model/Chat.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CurrencyRepository {
  Dio _dio = Dio();
  Future<Either<String, String>> updatePrice(
      int id, int buy, int sell, String status) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _token = _prefs.get('token');
      _dio.options.headers['authorization'] = 'Bearer $_token';
      if (buy > sell) {
        status = "up";
      } else {
        status = "down";
      }
      String completeUrl = '$currencyUpdateUrl$id';
      print(id);
      var updateResponse = await _dio.put(completeUrl,
          data: jsonEncode({
            "sell_status": status,
            "buy": buy,
            "sell": sell,
            "buy_status": "down"
          }));
      var mystatus = updateResponse.data['status'];
      if (mystatus == "success") {
        return Right(mystatus);
      }
      if (mystatus == "error") {
        return Left(mystatus);
      } else {
        return Left(mystatus);
      }
    } catch (e) {
      return Left("some error");
    }
  }

  Future<Either<String, List<DataChanges>>> DrawChart(
      int cityid, String fromdate, String todate) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.get('token');
    _dio.options.headers['authorization'] = 'Bearer $_token';
    //check time get
    String endFromdate;
    var now = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd");
    endFromdate = newFormat.format(now);
    if (fromdate == 'منذ يوم') {
      print('day');
      endFromdate = new DateTime(now.year, now.month, now.day, now.hour - 24,
              now.second, now.minute)
          .toString();
      print(endFromdate);
      print(todate);
      String completeUrl =
          '$chartUrl$cityid&from_date=$endFromdate&to_date=$todate';
      var chartResponse = await _dio.get(
        completeUrl,
      );
      print(chartResponse);
      if (chartResponse.data['status'] == "success") {
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        return Left('error');
      }
    } else if (fromdate == 'منذ ثلاثة أيام') {
      print('weak');
      print(endFromdate);
      print(todate);
      endFromdate = new DateTime(now.year, now.month, now.day - 26, now.hour,
              now.second, now.minute)
          .toString();
      String completeUrl =
          '$chartUrl$cityid&from_date=$endFromdate&to_date=$todate';
      var chartResponse = await _dio.get(
        completeUrl,
      );
      print(chartResponse);

      if (chartResponse.data['status'] == "success") {
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        return Left('error');
      }
    } else if (fromdate == 'منذ سبعة أيام') {
      print('day');
      print(endFromdate);
      print(todate);
      endFromdate = new DateTime(now.year, now.month, now.day - 21, now.hour,
              now.second, now.minute)
          .toString();
      String completeUrl =
          '$chartUrl$cityid&from_date=$endFromdate&to_date=$todate';
      var chartResponse = await _dio.get(
        completeUrl,
      );
      print(chartResponse);

      if (chartResponse.data['status'] == "success") {
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        return Left('error');
      }
    } else if (fromdate == 'منذ شهر') {
      endFromdate = new DateTime(now.year, now.month - 1, now.day, now.hour,
              now.microsecond, now.minute)
          .toString();
      print(endFromdate);
      print(todate);

      String completeUrl =
          '$chartUrl$cityid&from_date=$endFromdate&to_date=$todate';
      var chartResponse = await _dio.get(
        completeUrl,
      );

      if (chartResponse.data['status'] == "success") {
        print('enter');
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        print('enter');
        return Left('error');
      }
    } else {
      String completeUrl =
          '$chartUrl$cityid&from_date=$fromdate&to_date=$todate';
      var chartResponse = await _dio.get(
        completeUrl,
      );

      if (chartResponse.data['status'] == "success") {
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        return Left('error');
      }
    }
  }
}
