import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../server/server_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(allowFontScaling: false, height: 1334, width: 750)..init(context);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("百姓生活家"),
        ),
        body: FutureBuilder(
          builder: (BuildContext context, res) {
            if (res.hasData) {
              var data = json.decode(res.data.toString());
              // return Text(data["data"]["slider"].toString());
              // print(data.toString());
              return Column(
                children: <Widget>[HomePageSWiper((data["data"]["slides"] as List).cast())],
              );
            } else {
              return Text("加载中。。。。");
            }
          },
          future: serverMethods().getHomePageData({"lon": "115.02932", "lat": "35.76189"}),
        ),
      ),
    );
  }
}

class HomePageSWiper extends StatelessWidget {
  final List<Map> swiperUrl;
  HomePageSWiper(this.swiperUrl);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(333),
      child: Swiper(
        itemCount: swiperUrl.length,
        itemBuilder: (BuildContext context, index) {
          return Image.network(swiperUrl[index]["image"]);
        },
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
        autoplay: true,
      ),
    );
  }
}
