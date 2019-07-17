
import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {


  @override
  _TestWidgerState createState() => new _TestWidgerState();

}

class _TestWidgerState extends State<TestWidget>{


  int text = 1;
  
  void _updateText() {
    setState(() {
      ++text;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: Center(
        child: Text(text.toString()),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _updateText),
    );
  }

}