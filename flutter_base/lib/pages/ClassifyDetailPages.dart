import 'package:flutter/material.dart';
import 'package:flutter_base/api/Api.dart';
import 'package:flutter_base/base/BaseApplication.dart';
import 'package:flutter_base/contants/RounterContants.dart';
import 'package:flutter_base/utils/NetUtils.dart';
import 'package:flutter_base/utils/Utf8Utils.dart';

class ClassifyDetailComponent extends StatefulWidget {
  final type;

  ClassifyDetailComponent({String type = "Android"})
      : this.type = type;

  _NewsListState createState() => new _NewsListState();
}

class _NewsListState extends State<ClassifyDetailComponent> {
  int _page = 1;
  List listData = new List();
  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("文章", style: new TextStyle(color: Colors.white)),
//        iconTheme: new IconThemeData(color: Colors.white),
//      ),
      body: new RefreshIndicator(
        child: new ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(2.0),
          itemCount: listData == null ? 0 : listData.length,
          itemBuilder: (context, i) {
            return new InkWell(
                onTap: () {
                  String title = "webview";
                  String url = Utf8Utils.lineToASC(listData[i]['url']);
                  Application.router.navigateTo(context,
                      Routes.webLink + "?" + Routes.webTitle + "=$title&" + Routes.webUrl + "=$url");
                },
                child: new Card(
                  child: new ListTile(
                    title: new Text(listData[i]['desc']),
                    subtitle: new Text(listData[i]['who']),
                  ),
                ));
          },
          controller: _controller,
        ),
        onRefresh: _pullToRefresh,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      //最大可滑动距离
      var maxScroll = _controller.position.maxScrollExtent;
      //当前距离
      var pixels = _controller.position.pixels;
      //滑动到底部
      if (maxScroll == pixels) {
        _page++;
        loadingData();
      }
    });
    loadingData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void loadingData() {
    var type = widget.type;
    NetUtils.get(Api.GANK_FEED + "$type/20/$_page", (data) {
      if (data != null) {
        setState(() {
          if (_page == 1) {
            listData.clear();
          }
          listData.addAll(data);
        });
      }
    });
  }

  Future<Null> _pullToRefresh() async {
    print("刷新成功");
    _page = 1;
    loadingData();
    return null;
  }
}
