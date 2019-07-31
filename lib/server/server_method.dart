import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'server_url.dart';

class serverMethods {
  getHomePageData(Map data) async {
    try {
      Dio dio = new Dio();
      dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
      Response res = await dio.post(servarUrl["homePageData"], data: data);
      if (res.statusCode == 200) {
        return res;
      } else {
        throw Exception("后台接口出错！");
      }
    } catch (e) {
      return print(e);
    }
  }
}
