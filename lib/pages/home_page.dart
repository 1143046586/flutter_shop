import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../server/server_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

List<Map> hotGoodsList = [];
int page = 1;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// with AutomaticKeepAliveClientMixin
class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var getHomeData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("homeInit");
    getHomeData = request("homePageData", data: {
      "lon": "115.02932",
      "lat": "35.76189",
    });
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
            if (res.hasData) {
              print("首页加载数据********");
              var data = json.decode(res.data.toString());

              List<Map> homePageSwipeList = (data["data"]["slides"] as List).cast();
              List<Map> homePageNavList = (data["data"]["category"] as List).cast();
              String adUrl = data["data"]["advertesPicture"]["PICTURE_ADDRESS"];
              String bossPhoneImage = data["data"]["shopInfo"]["leaderImage"];
              String bossPhoneNumber = data["data"]["shopInfo"]["leaderPhone"];
              List<Map> recommendList = (data["data"]["recommend"] as List).cast();
              String floorTitle1 = data["data"]["floor1Pic"]["PICTURE_ADDRESS"];
              String floorTitle2 = data["data"]["floor2Pic"]["PICTURE_ADDRESS"];
              String floorTitle3 = data["data"]["floor3Pic"]["PICTURE_ADDRESS"];
              List<Map> floorContent1 = (data["data"]["floor1"] as List).cast();
              List<Map> floorContent2 = (data["data"]["floor2"] as List).cast();
              List<Map> floorContent3 = (data["data"]["floor3"] as List).cast();
              return EasyRefresh(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      HomePageSWiper(homePageSwipeList),
                      NavList(homePageNavList),
                      ADbanner(adUrl: adUrl),
                      BossPhone(bossPhoneImage: bossPhoneImage, bossPhoneNumber: bossPhoneNumber),
                      Recommend(recommend: recommendList),
                      FloorTitle(titleImageSrc: floorTitle1),
                      FloorContent(contentList: floorContent1),
                      FloorTitle(titleImageSrc: floorTitle2),
                      FloorContent(contentList: floorContent2),
                      FloorTitle(titleImageSrc: floorTitle3),
                      FloorContent(contentList: floorContent3),
                      HotGoods(),
                    ],
                  ),
                ),
                onLoad: () async {
                  request("homePageBelowConten", data: {"page": page}).then((res) {
                    print("到底加载");
                    var data = json.decode(res.data.toString());
                    setState(() {
                      hotGoodsList.addAll((data["data"] as List).cast());
                      page++;
                    });
                  });
                },
                onRefresh: () async {
                  print("上拉刷新");
                },
                header: MaterialHeader(),
                footer: MaterialFooter(),
              );
              // return
            } else {
              return Container(
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }
          },
          future: getHomeData,
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
        physics: NeverScrollableScrollPhysics(),
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Image.network(recommendItem["image"]),
          Text(
            "￥${recommendItem["mallPrice"]}",
          ),
          Text(
            "￥${recommendItem["price"]}",
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
              fontSize: 12.0,
            ),
          )
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
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.black12, width: 1),
              ),
            ),
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

class FloorTitle extends StatelessWidget {
  final String titleImageSrc;
  FloorTitle({Key key, this.titleImageSrc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Image.network(titleImageSrc),
    );
  }
}

class FloorContent extends StatelessWidget {
  final List<Map> contentList;
  FloorContent({Key key, this.contentList}) : super(key: key);
  Widget getItemPic(String src) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print("点击了floor图片：$src");
        },
        child: Image.network(src),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              getItemPic(contentList[0]["image"]),
              getItemPic(contentList[3]["image"]),
            ],
          ),
          Column(
            children: <Widget>[
              getItemPic(contentList[1]["image"]),
              getItemPic(contentList[2]["image"]),
              getItemPic(contentList[4]["image"]),
            ],
          )
        ],
      ),
    );
  }
}

class HotGoods extends StatefulWidget {
  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  @override
  void initState() {
    super.initState();
    request("homePageBelowConten", data: {"page": page}).then((res) {
      var data = json.decode(res.data.toString());
      setState(() {
        hotGoodsList = (data["data"] as List).cast();
        page++;
      });
    });
  }

  Widget _hotGoodsTitle() {
    return Container(
      height: ScreenUtil().setWidth(80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(50),
            height: ScreenUtil().setWidth(50),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Text(
              "火",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Text("火爆专区")
        ],
      ),
    );
  }

  Widget _hotGoodsItem(Map item) {
    return Container(
      width: ScreenUtil().setWidth(360),
      color: Colors.white,
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Image.network(item["image"]),
          Text(
            item["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 14.0,
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                '￥${item["mallPrice"]}',
                style: TextStyle(color: Colors.black),
              ),
              Container(
                width: ScreenUtil().setWidth(200),
                alignment: Alignment.center,
                child: Text(
                  '￥${item["price"]}',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black12, decoration: TextDecoration.lineThrough),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _hotGoodsTitle(),
          Container(
            width: ScreenUtil().setWidth(750),
            child: Wrap(
              children: hotGoodsList.map(_hotGoodsItem).toList(),
              spacing: 10,
              alignment: WrapAlignment.center,
              runSpacing: 10,
            ),
          )
        ],
      ),
    );
  }
}
