import 'package:flutter/material.dart';
import 'package:flutter_base/api/Api.dart';
import 'package:flutter_base/base/BaseApplication.dart';
import 'package:flutter_base/contants/RounterContants.dart';
import 'package:flutter_base/utils/NetUtils.dart';
import "package:flutter_base/refresh/pull_to_refresh.dart";
import "package:flutter_swiper/flutter_swiper.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/utils/Utf8Utils.dart';
// 微信公众号作者列表
class WXArticleComponent extends StatefulWidget {
  WXArticleComponent(
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

class _NewsListState extends State<WXArticleComponent> {
  List listData = new List();
  RefreshController _refreshController;
  List imageList =["http://hbimg.b0.upaiyun.com/ccc849c2c4047b6519fac888c4b4b01876cabde48a167-S6HwWX_fw658",
  "http://hbimg.b0.upaiyun.com/bd154cb88681abe52b0f0dac6da70d6feb80e135905cf-Gycd7g_fw658",
  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1560255983032&di=69df5d0d4166a255324ea893fc295181&imgtype=0&src=http%3A%2F%2Fbpic.588ku.com%2Fback_pic%2F03%2F74%2F09%2F2657bbed7977b0c.jpg"];

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 160,
              child: Swiper(
                itemCount: imageList.length,
                autoplay: true,
                itemBuilder: (BuildContext context, int index) {
                  return  new CachedNetworkImage(
                  placeholder: CupertinoActivityIndicator(),
                  imageUrl: imageList[index],
                  fit: BoxFit.fitWidth,
                  );
                },
                onTap: (index){
                  String title = "blogs";
                  String url = Utf8Utils.lineToASC("https://lpfroc.github.io");

                  Application.router.navigateTo(context,
                      Routes.webLink + "?" + Routes.webTitle + "=$title&" + Routes.webUrl + "=$url");
                },
                pagination: SwiperPagination(),


              ),

            ),
            Expanded(
              child: SmartRefresher(
                child: new ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(2.0),
                  itemCount: listData == null ? 0 : listData.length,
                  itemBuilder: (context, i) {
                    return new InkWell(

                        child: new Card(
                          child: new ListTile(
                            title: new Text(listData[i]['name']),
                            trailing: Icon(Icons.keyboard_arrow_right),

                            onTap: () {
                              int id = listData[i]['id'];
                              Application.router
                                  .navigateTo(context, Routes.wxArticleListLink + "?" + Routes.wxArticleId + "=$id");
                            },
                          ),
                        ));
                  },
                ),
                controller:_refreshController,
                enablePullDown: true,
                enablePullUp: false,
                onHeaderRefresh: _pullToRefresh,

              ),

            ),

          ],
        ),
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    print("initState");
    loadingData();
  }

  void loadingData() {
    print("loadingData");

    NetUtils.get(Api.WAN_WXARTICLE, (data) {
      print(data);

      if (data != null) {
        _refreshController.sendBack(true, RefreshStatus.idle);

        setState(() {
          listData.clear();
          listData.addAll(data);
        });
      }
    });
  }

  Future<Null> _pullToRefresh() async {
    print("刷新成功");
    print("_pullToRefresh");
    loadingData();
    return null;
  }
}
