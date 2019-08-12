import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './home_page.dart';
import './serach_page.dart';
import './cart_page.dart';
import './user_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with SingleTickerProviderStateMixin {
  final List<BottomNavigationBarItem> bottomBars = [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text("首页")),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), title: Text("分类")),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.shopping_cart), title: Text("购物车")),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.profile_circled), title: Text("会员中心"))
  ];
  final List<Widget> pageList = [
    HomePage(),
    SearchPage(),
    CartPage(),
    UserPage(),
  ];
  int currentIndex = 0;
  TabController mController;
  PageController mPageController;
  @override
  void initState() {
    super.initState();
    mController = TabController(
      length: pageList.length,
      vsync: this,
    );
    mPageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(allowFontScaling: false, height: 1334, width: 750)..init(context);
    return Container(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 244, 244, 1),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: bottomBars,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              mPageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
              currentIndex = index;
            });
          },
        ),
        body: PageView(
          children: pageList,
          controller: mPageController,
          pageSnapping: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
