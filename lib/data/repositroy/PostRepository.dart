import 'dart:convert';

import 'package:central_borssa/constants/url.dart';
import 'package:central_borssa/data/model/Post/GetPost.dart';
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

      print(postResponse);
      if (postResponse.data['status'] == "success") {
        print('from here');
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

  late List<Posts> Mylist;

  Future<Either<String, PostGet>> getAllPost(int page, int count) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var token = _pref.get('token');
      dio.options.headers['authorization'] = 'Bearer $token';
      String urltest =
          "https://ferasalhallak.online/api/posts?page=$page&sort=desc&pageSize=$count";
      var getallPost = await dio.get(urltest);

      var data = new PostGet.fromJson(getallPost.data['data']);

      return Right(data);
    } catch (e) {
      return Left('error');
    }
  }
}
