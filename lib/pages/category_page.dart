import 'dart:convert';
import 'package:flutter/material.dart';
import '../server/server_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/category_provide.dart';
import '../model/category_model.dart';

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
      Provide.value<CategoryProvide>(context).setWineTypeList(category.data);
      print(data);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
          ],
        ),
      ),
    );
  }
}

class GoodsType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Provide<CategoryProvide>(
        builder: (context, child, categoryProvide) {
          print(categoryProvide.wineTypeList);
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: categoryProvide.wineTypeList.length,
            itemBuilder: (context, index) {
              return Container(
                child: Text("${categoryProvide.wineTypeList[index].mallCategoryName}"),
              );
            },
          );
        },
      ),
    );
  }
}
