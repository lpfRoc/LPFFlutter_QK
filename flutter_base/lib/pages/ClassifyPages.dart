import 'package:flutter/material.dart';
import 'package:flutter_base/pages/ClassifyTagPage.dart';

class ClassifyComponent extends StatefulWidget {
  final message;

  ClassifyComponent({String message = "Android"}) : this.message = message;

  @override
  State<StatefulWidget> createState() => _ClassifyPageState();
}

class _ClassifyPageState extends State<ClassifyComponent>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  ClassifyTabPage classifyTabPage;
  List<ClassifyTabPage> classifyTab;

  @override
  void initState() {
    super.initState();
    classifyTabPage = new ClassifyTabPage();
    classifyTab = classifyTabPage.initClassify();
    _controller = new TabController(vsync: this, length: classifyTab.length);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new TabBar(
          controller: _controller,
          indicatorColor: Theme.of(context).primaryColor,
          isScrollable: true,
          tabs: classifyTab.map((ClassifyTabPage page) {
            return new Tab(text: page.text);
          }).toList(),
        ),
      ),
      body: new TabBarView(
          controller: _controller,
          children: classifyTab.map((ClassifyTabPage page) {
            return page.detailPage;
          }).toList()),
    );
  }
}
