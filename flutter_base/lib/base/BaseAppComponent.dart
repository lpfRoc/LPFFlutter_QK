import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_base/base/BaseApplication.dart';
import 'package:flutter_base/contants/RounterContants.dart';
import 'package:flutter_base/utils/BottomBarUtils.dart';
import 'package:flutter_base/widgets/LeftDrawer.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_base/model/ThemeColorEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppComponent extends StatefulWidget {
  @override

  State createState() {
    return new AppComponentState();
  }
}

class AppComponentState extends State<AppComponent> {

  AppComponentState() {
    //注入路由
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  Color themeColor = Color.fromARGB(255, 254, 213, 50);

  String themeTitle = "暖色主题";

  @override
  void initState() {
    super.initState();
    Application.eventBus = new EventBus();
    this.registerThemeEvent();
    getTheme("主题");
  }


  void registerThemeEvent() {
    Application.eventBus.on<ThemeColorEvent>().listen((event){
      this.changeTheme(event);
    });
  }

  void getTheme(String key)async {

    // 构建sp类
    SharedPreferences sp = await SharedPreferences.getInstance();

    // 读取
    themeTitle = sp.get(key);
    print(themeTitle);

    if (themeTitle == "暖色主题"){
      setState(() {
        themeColor =  Color.fromARGB(255, 254, 213, 50);

      });
    }else if (themeTitle == "暗黑主题"){
      setState(() {
        themeColor = Color.fromARGB(255, 60, 63, 65);

      });

    }else{
      themeColor = Color.fromARGB(255, 254, 213, 50);

    }

  }


  void changeTheme(ThemeColorEvent event) {
    setState(() {
      themeColor = event.color;
    });
  }


    String _title = "首页";

  void setBar(index){

    switch (index) {
      case 0:
        _title = "首页";
        break;
      case 1:
        _title = "发现";
        break;
      case 2:
        _title = "福利";
        break;
      case 3:
        _title = "我的";
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    BottomBarUtils.initData();
    final app = new MaterialApp(
      title: 'Fluro',
      theme: new ThemeData(
        primaryColor: themeColor,
      ),
      home: new Scaffold(
          appBar: new AppBar(
              backgroundColor: themeColor,
              title: new Text(_title, style: new TextStyle(color: Colors.black)),
              iconTheme: new IconThemeData(color: Colors.black)),
          body: BottomBarUtils.getBody(),
          bottomNavigationBar: new CupertinoTabBar(
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem(
                  icon: BottomBarUtils.getTabIcon(0), title: BottomBarUtils.getTabTitle(0)),
              new BottomNavigationBarItem(
                  icon: BottomBarUtils.getTabIcon(1), title: BottomBarUtils.getTabTitle(1)),
              new BottomNavigationBarItem(
                  icon: BottomBarUtils.getTabIcon(2), title: BottomBarUtils.getTabTitle(2)),
              new BottomNavigationBarItem(
                  icon: BottomBarUtils.getTabIcon(3), title: BottomBarUtils.getTabTitle(3)),
            ],
            currentIndex: BottomBarUtils.getTabIndex(),
            onTap: (index) {
              setBar(index);
              setState(() {
                BottomBarUtils.setTabIndex(index);

              });
            },
          ),
          drawer: new BaseDrawer()),
      onGenerateRoute: Application.router.generator,
    );
    print("initial route = ${app.initialRoute}");
    return app;
  }
}
