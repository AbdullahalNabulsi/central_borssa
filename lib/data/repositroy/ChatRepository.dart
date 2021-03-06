import 'dart:convert';

import 'package:central_borssa/constants/url.dart';
import 'package:central_borssa/data/model/Chat.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  Dio _dio = new Dio();
  late List<Message> messages = [];

  Future<Either<String, Data>> allMessages(int page, int pageSize) async {
    messages.clear();

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.getString('token');

    _dio..options.headers['authorization'] = 'Bearer $_token';

    var response = await _dio.get('$allMessagesUrl$page&pageSize=$pageSize');
    print(response.data['status']);
    var status = response.data['status'];
    var allcurrency = Data.fromJson(response.data['data']);
    // print(allcurrency);

    // print(allcurrency);
    if (status == "success") {
      return Right(allcurrency);
    } else {
      return Left("error");
    }
  }

  Future<Either<String, String>> sendMessages(String message) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.getString('token');

    _dio..options.headers['authorization'] = 'Bearer $_token';

    var response =
        await _dio.post(sendMessageUrl, data: jsonEncode({"message": message}));
    print(response.data['status']);
    var status = response.data['status'];

    if (status == "success") {
      return Right(status);
    } else {
      return Left("error");
    }
  }
}
