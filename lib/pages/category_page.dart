import 'dart:convert';
import 'package:flutter/material.dart';
import '../server/server_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/category_provide.dart';
import '../model/category_model.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

bool enableControlFinishLoad = false;
EasyRefreshController _controller = EasyRefreshController();
class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _getCategory() {
    request("getCategory").then((res) {
      var data = json.decode(res.toString());
      var category = CategoryModel.fromJson(data);
      Provide.value<CategoryProvide>(context).setGoodsTypeList(category.data);
      Provide.value<CategoryProvide>(context).setGoodsSubTypeList(category.data[0].bxMallSubDto);
    });
  }

  @override
  void initState() {
    super.initState();
    print("searchinit");
    _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("商品分类"),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            GoodsType(),
            GoodsTypeContent(),
          ],
        ),
      ),
    );
  }
}

class GoodsType extends StatefulWidget {
  @override
  _GoodsTypeState createState() => _GoodsTypeState();
}

class _GoodsTypeState extends State<GoodsType> {
  int subSelectIndex = 0;
  _getGoodsTypeItemBG(currentIndex, selectIndex) {
    if (currentIndex == selectIndex) {
      return Colors.pink;
    } else {
      return Colors.white;
    }
  }

  _getGoodsTypeItemTextColor(currentIndex, selectIndex) {
    if (currentIndex == selectIndex) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Color.fromRGBO(240, 240, 240, 1.0),
            width: 1.0,
          ),
        ),
      ),
      child: Provide<CategoryProvide>(
        builder: (context, child, categoryProvide) {
          if (categoryProvide.goodsTypeList.length <= 0) {
            return Center(
              child: Text("加载中。。。"),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: categoryProvide.goodsTypeList.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10.0),
                  height: ScreenUtil().setWidth(100),
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromRGBO(240, 240, 240, 1.0),
                        ),
                      ),
                      color: _getGoodsTypeItemBG(index, subSelectIndex)),
                  child: Text(
                    "${categoryProvide.goodsTypeList[index].mallCategoryName}",
                    style: TextStyle(color: _getGoodsTypeItemTextColor(index, subSelectIndex)),
                  ),
                ),
                onTap: () {
                  print("点击了商品分类列表$index");
                  setState(() {
                    subSelectIndex = index;
                  });
                  
                  _controller.finishLoad(success: true,noMore: false);
                  enableControlFinishLoad = false;
                  Provide.value<CategoryProvide>(context).setGoodsSubTypeList(
                    categoryProvide.goodsTypeList[index].bxMallSubDto,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class GoodsTypeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(570),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: GoodsSubType(),
          ),
          Expanded(
            flex: 1,
            child: GoodsList(),
          )
        ],
      ),
      // child: Column(
      //   children: <Widget>[
      //     GoodsSubType(),
      //     GoodsList(),
      //   ],
      // ),
    );
  }
}

class GoodsSubType extends StatefulWidget {
  @override
  _GoodsSubTypeState createState() => _GoodsSubTypeState();
}

class _GoodsSubTypeState extends State<GoodsSubType> {
  _getGoodsSubTypeTextColor(currentIndex, selectIndex) {
    if (currentIndex == selectIndex) {
      return Colors.pink;
    } else {
      return Colors.black;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(80),
      alignment: Alignment.centerLeft,
      child: Provide<CategoryProvide>(
        builder: (BuildContext content, child, categoryProvide) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index) {
              return InkWell(
                child: Container(
                  // width: ScreenUtil().setWidth(80),
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  alignment: Alignment.center,
                  child: Text(
                    "${categoryProvide.goodsSubTypeList[index].mallSubName}",
                    style: TextStyle(
                      color: _getGoodsSubTypeTextColor(index, categoryProvide.subSelectIndex),
                    ),
                  ),
                ),
                onTap: () {
                  _controller.finishLoad(success: true,noMore: false);
                  enableControlFinishLoad = false;
                  Provide.value<CategoryProvide>(context).setGoodsSubTypeIndex(
                    index,
                    categoryProvide.goodsSubTypeList[index].mallCategoryId,
                    categoryProvide.goodsSubTypeList[index].mallSubId,
                  );
                },
              );
            },
            itemCount: categoryProvide.goodsSubTypeList.length,
          );
        },
      ),
    );
  }
}

class GoodsList extends StatefulWidget {
  @override
  _GoodsListState createState() => _GoodsListState();
}

class _GoodsListState extends State<GoodsList> {
  Widget _goodsListItem(item) {
    return Container(
      width: ScreenUtil().setWidth(270),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2.0, 2.0),
            blurRadius: 1.0,
            spreadRadius: 0.5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(item.image),
          Text(
            "${item.goodsName}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.pink,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("￥${item.presentPrice}"),
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child: Text(
                  "￥${item.oriPrice}",
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                  ),
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
      padding: EdgeInsets.all(3.5),
      child: EasyRefresh(
        controller: _controller,
        enableControlFinishLoad: enableControlFinishLoad,
        child: Provide<CategoryProvide>(
          builder: (BuildContext context, child, categoryProvide) {
            return Wrap(
              spacing: 5.0,
              runSpacing: 5.0,
              alignment: WrapAlignment.start,
              children: categoryProvide.goodsList.map((item) {
                return _goodsListItem(item);
              }).toList(),
            );
          },
        ),
        onLoad: () async {
          print("上拉加载");
          Provide.value<CategoryProvide>(context).setGoodsList(callBack: () {
            enableControlFinishLoad = true;
            _controller.finishLoad(success: true, noMore: true);
          });
        },
        onRefresh: () async {
          print("下拉刷新");
          Provide.value<CategoryProvide>(context).reloadGoodsList();
        },
        header: MaterialHeader(),
        footer: MaterialFooter(),
      ),
    );
  }
}
