import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../server/server_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("百姓生活家"),
        ),
        body: FutureBuilder(
          builder: (BuildContext context, res) {
            print("首页加载数据********");
            if (res.hasData) {
              var data = json.decode(res.data.toString());
              List<Map> homePageSwipeList = (data["data"]["slides"] as List).cast();
              List<Map> homePageNavList = (data["data"]["category"] as List).cast();
              String adUrl = data["data"]["advertesPicture"]["PICTURE_ADDRESS"];
              String bossPhoneImage = data["data"]["shopInfo"]["leaderImage"];
              String bossPhoneNumber = data["data"]["shopInfo"]["leaderPhone"];
              List<Map> recommendList = (data["data"]["recommend"] as List).cast();
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    HomePageSWiper(homePageSwipeList),
                    NavList(homePageNavList),
                    ADbanner(
                      adUrl: adUrl,
                    ),
                    BossPhone(bossPhoneImage: bossPhoneImage, bossPhoneNumber: bossPhoneNumber),
                    Recommend(
                      recommend: recommendList,
                    )
                  ],
                ),
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

class NavList extends StatelessWidget {
  Widget _navListItem(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print("点击了导航");
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item["image"],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item["mallCategoryName"])
        ],
      ),
    );
  }

  List navList;
  NavList(this.navList);
  @override
  Widget build(BuildContext context) {
    navList = navList.map((item) {
      return _navListItem(context, item);
    }).toList();
    if (navList.length > 10) {
      navList.removeRange(10, navList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(5.0),
      child: GridView(
        padding: EdgeInsets.all(4.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 3.0,
          crossAxisCount: 5,
          crossAxisSpacing: 3.0,
        ),
        children: navList,
      ),
    );
  }
}

class ADbanner extends StatelessWidget {
  final String adUrl;
  const ADbanner({Key key, this.adUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adUrl),
    );
  }
}

class BossPhone extends StatelessWidget {
  final String bossPhoneImage;
  final String bossPhoneNumber;
  const BossPhone({Key key, this.bossPhoneImage, this.bossPhoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Image.network(bossPhoneImage),
        onTap: _launchURL,
      ),
    );
  }

  _launchURL() async {
    String url = 'tel:' + bossPhoneNumber;
    if (await canLaunch(url)) {
      await launch("https://www.baidu.com");
    } else {
      throw '不能发射该地址 $url';
    }
  }
}

class RecommendItem extends StatelessWidget {
  final Map recommendItem;
  RecommendItem({Key key, this.recommendItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(330),
      width: ScreenUtil().setWidth(250),
      padding: EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: Colors.white, border: Border(right: BorderSide(color: Colors.black87, width: 1))),
      child: Column(
        children: <Widget>[
          Image.network(recommendItem["image"]),
          Text("￥${recommendItem["mallPrice"]}"),
          Text("￥${recommendItem["price"]}")
        ],
      ),
    );
  }
}

class Recommend extends StatelessWidget {
  final List<Map> recommend;
  Recommend({Key key, this.recommend}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(400),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              "商品推荐",
              style: TextStyle(color: Colors.pink),
            ),
            height: ScreenUtil().setWidth(70),
            padding: EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            decoration:
                BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
          ),
          Container(
            height: ScreenUtil().setWidth(330),
            child: ListView.builder(
              itemCount: recommend.length,
              itemBuilder: (BuildContext context, index) {
                return RecommendItem(
                  recommendItem: recommend[index],
                );
              },
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }
}
