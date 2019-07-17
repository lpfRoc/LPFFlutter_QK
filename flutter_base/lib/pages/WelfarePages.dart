import 'package:flutter/material.dart';
import 'package:flutter_base/api/Api.dart';
import 'package:flutter_base/utils/NetUtils.dart';
import 'package:flutter_base/widgets/PhotoItemView.dart';
import "package:flutter_base/refresh/pull_to_refresh.dart";
// 福利妹子单图列表
class WelfareComponent extends StatefulWidget {
  WelfareComponent(
      {String message = "Testing",
      Color color = const Color(0xFFFFFFFF),
      String result})
      : this.message = message,
        this.color = color,
        this.result = result;
  final String message;
  final Color color;
  final String result;

  _NewsListState createState() => new _NewsListState();
}

class _NewsListState extends State<WelfareComponent> {

  int _page = 1;
  static final int _pageSize = 10;
  List listData = new List();
  ScrollController _controller = new ScrollController();
  RefreshController _refreshController;

  @override
  Widget build(BuildContext context) {
    return new SmartRefresher(
      child: new ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(2.0),
        itemCount: listData == null ? 0 : listData.length,
        itemBuilder: (context, i) {
          return BuildWelfareRows(context, listData[i]['url'], listData[i]['desc']);
        },
        controller: _controller,
      ),
      controller:_refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onHeaderRefresh: _pullToRefresh,
      onFooterRefresh: _downToRefresh,
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
//    _controller.addListener(() {
//      //最大可滑动距离
//      var maxScroll = _controller.position.maxScrollExtent;
//      //当前距离
//      var pixels = _controller.position.pixels;
//      //滑动到底部
//      if (maxScroll == pixels) {
//        _page++;
//        loadingData();
//      }
//    });
    loadingData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void loadingData() {
    NetUtils.get(Api.GANK_WELFARE + '$_pageSize/$_page', (data) {
      if (data != null) {
        _refreshController.sendBack(true, RefreshStatus.idle);

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
    print("刷新成功123");
    _page = 1;
    loadingData();
    return null;
  }

  Future<Null> _downToRefresh() async {
    print("刷新成功123");
    _page++;
    loadingData();
    return null;
  }
}
