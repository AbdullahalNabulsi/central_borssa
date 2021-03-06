import 'dart:convert';

import 'package:central_borssa/constants/url.dart';
import 'package:central_borssa/data/model/Post/GetPost.dart';
import 'package:central_borssa/presentation/Home/All_post.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostRepository {
  Dio dio = Dio();

  Future<Either<String, String>> addNewPost(String body, String? image) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var token = _pref.get('token');
      dio.options.headers['authorization'] = 'Bearer $token';
      var postResponse;
      if (image == null || image.isEmpty) {
        postResponse =
            await dio.post(addPost, data: jsonEncode(({"body": body})));
      } else if (image.isNotEmpty) {
        postResponse = await dio.post(addPost,
            data: jsonEncode(({"body": body, "image": image})));
      }

      // print(postResponse);
      if (postResponse.data['status'] == "success") {
        // print('from here');
        return Right('success');
      } else if (postResponse.data['status'] == "error") {
        return Left('error');
      } else {
        return Left('error');
      }
    } catch (e) {
      return Left('error is catched');
    }
  }

  Future<Either<String, String>> deletePost(int id) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var token = _pref.get('token');
      dio.options.headers['authorization'] = 'Bearer $token';
      var postResponse;
      String url = 'https://centralborsa.com/api/posts/$id';
      postResponse = await dio.delete(url);
      if (postResponse.data['status'] == "success") {
        return Right('success');
      } else if (postResponse.data['status'] == "error") {
        return Left('error');
      } else {
        return Left('error');
      }
    } catch (e) {
      return Left('error is catched');
    }
  }

  Future<Either<String, PostGet>> getAllPost(int page, int count) async {
    print('from get all post');
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.get('token');
    dio.options.headers['authorization'] = 'Bearer $token';
    String fullUrl =
        "https://centralborsa.com/api/posts?page=$page&sort=desc&pageSize=$count";
    var getallPost = await dio.get(fullUrl);
    var data = new PostGet.fromJson(getallPost.data['data']);
    print(getallPost);
    return Right(data);
  }

  Future<Either<String, PostGet>> getAllPostByCityName(
    List<CityId?> citiesid,
    String sortby,
    int page,
    int pageSize,
  ) async {
    var cities;
    if (citiesid.isNotEmpty) {
      cities = jsonEncode(citiesid);
      // print(cities);
    }
    print('city id');
    print(cities);
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.get('token');
    dio.options.headers['authorization'] = 'Bearer $token';
    String fullUrl =
        "$allPostByCityName&page=$page&sort=desc&pageSize=$pageSize&city_id=$cities";

    print(fullUrl);
    var getallPost = await dio.get(fullUrl);
    print('from city name');
    print(getallPost.data);
    var data = new PostGet.fromJson(getallPost.data['data']);

    return Right(data);
  }
}
