import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


 class WebPage extends StatefulWidget {
  final title;
  final url;
  WebPage(this.title, this.url);
     @override
     _WebPageState createState() => _WebPageState();
   }

 class _WebPageState extends State<WebPage> {
   TextEditingController controller = TextEditingController();
   FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

   var urlString = "";
   String _errorStr = "";
   launchUrl() {
     setState(() {
        urlString = controller.text.length>0?controller.text:urlString;
        if(!urlString.contains("://")|| !urlString.startsWith("http")){
          _errorStr = "请输入合法网址";
        }else{
          _errorStr = "";
        }
       flutterWebviewPlugin.reloadUrl(urlString);
     });
   }

     @override
   void initState() {
     super.initState();

     flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
       print(wvs.type);

       setState(() {

         urlString = wvs.url;
       });
       });
   }

   @override
   Widget build(BuildContext context) {
    return WebviewScaffold(
       appBar: AppBar(
         title: TextField(
          autofocus: false,
          controller: controller,
           textInputAction: TextInputAction.go,
          onSubmitted: (url) => launchUrl(),
           style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: urlString,
            hintStyle: TextStyle(color: Colors.white),
            errorText:_errorStr,
          ),
        ),
         actions: <Widget>[
          IconButton(
               icon: Icon(Icons.navigate_next),
             onPressed: () => launchUrl(),
           )
         ],
       ),
       url: urlString.length>0 ? urlString : widget.url,
       withZoom: false,
     );
   }
 }