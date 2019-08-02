import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './home_page.dart';
import './serach_page.dart';
import './cart_page.dart';
import './user_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
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
  // Widget currentPage;
  PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // currentPage = pageList[currentIndex];
    _pageController = new PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 244, 244, 1),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: bottomBars,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
              _pageController.animateToPage(index,
                  duration: new Duration(milliseconds: 500), curve: new ElasticInOutCurve(4));
            });
          },
        ),
        body: PageView(
          children: pageList,
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
