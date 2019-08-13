import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/category_provide.dart';

void main() {
  var categoryProvide = CategoryProvide();
  var providers = Providers();
  providers..provide(Provider<CategoryProvide>.value(categoryProvide));
  runApp(ProviderNode(
    child: MyApp(),
    providers: providers,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: "百姓生活+",
        home: IndexPage(),
        debugShowCheckedModeBanner: false,
        // showPerformanceOverlay: true,
        theme: ThemeData(primaryColor: Colors.pink),
      ),
    );
  }
}
