import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category_model.dart';
import '../model/category_goods_list_model.dart';
import '../server/server_method.dart';
import 'dart:convert';

class CategoryProvide with ChangeNotifier {
  List goodsTypeList = [];
  List goodsSubTypeList = [];
  int subSelectIndex = 0;
  int goodsListPage;
  String categoryId;
  String categorySubId;
  List goodsList = [];
  setGoodsTypeList(List list) {
    goodsTypeList = list;
    notifyListeners();
  }

  setGoodsSubTypeList(List list) {
    BxMallSubDto all = BxMallSubDto(
      comments: "",
      mallSubId: "",
      mallCategoryId: list[0].mallCategoryId,
      mallSubName: "全部",
    );
    goodsSubTypeList = [all];
    goodsSubTypeList.addAll(list);
    subSelectIndex = 0;
    goodsListPage = 1;
    categoryId = list[0].mallCategoryId;
    categorySubId = "";
    notifyListeners();
    setGoodsList();
  }

  setGoodsSubTypeIndex(index, goodsTypeId, goodsSubTypeId) async {
    subSelectIndex = index;
    goodsListPage = 1;
    categoryId = goodsTypeId;
    categorySubId = goodsSubTypeId;
    notifyListeners();
    setGoodsList();
  }

  setGoodsList() async {
    var data = {
      'categoryId': categoryId,
      'categorySubId': categorySubId,
      'page': goodsListPage,
    };
    await request('getMallGoods', data: data).then((val) {
      var data = json.decode(val.toString());
      print('分类商品列表：>>>>>>>>>>>>>${data}');
      data = CategoryGoodsListModel.fromJson(data);
      goodsList = data.data;
      goodsListPage++;
      notifyListeners();
    });
  }
}
