import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/services/router.dart';
import 'package:flutter_module/services/navigation_service.dart';
import 'package:flutter_module/services/utils.dart';
import 'dart:convert';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const platformMethodChannel = const MethodChannel('com.methodchannel/test');
  String nativeMessage = '';
  String content = "";
  MethodChannel _methodChannel = MethodChannel("methodChannel");

  StreamSubscription _timerSubscription;
  final stream = const EventChannel('navigateParams');
  String a = 'default';


  void _updateRoute(dynamic screenName) {
    List<String> a = screenName.toString().split(',');
    navigateToFlutterScreen(fromNativeActivity: a[1], screenName: a[0]);

  }


  @override
  void initState() {
    super.initState();
    _enableTimer();

    //设置监听
    _methodChannel.setMethodCallHandler(_methodChannelHandler);
  }

  void _enableTimer() {
    if (_timerSubscription == null) {
      _timerSubscription = stream.receiveBroadcastStream().listen(_updateRoute);
    }
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      initialRoute: 'default',
      navigatorKey: navigatorKey,
      onGenerateRoute: generateRoute,

    );
  }

  List<dynamic> phoneNumbersList = <dynamic>[];
  NewModel response = NewModel();

  Future<Null> greetings() async {
    NewModel _message;
    String text = "This will be a model";
    int m = 3;
    try {
      var response = await platformMethodChannel.invokeMethod('getModel',{'title': 'ggg', 'id': 2});
      setState(() {
        _message = NewModel.fromJson(json.decode(response));
        print(_message.title);
      });
    } on PlatformException catch (e) {
      print("e.message");
      print(e.message);
    }
  }
  /// Flutter 调用原生
  Future<void> callNative() async {
    print("----------------callNative--------------------");
    var res = await _methodChannel.invokeMethod("callNative", {"arg1": "I am from Flutter"});
    //Android收到调用之后返回的数据
    setState(() {
      content = res;
      print("----------------Flutter返回到安卓数据 $content--------------------");
    });
  }
  //方法是异步的
  Future<String> _methodChannelHandler(MethodCall call) async {
    String result = "";
    switch (call.method) {
    //收到Android的调用，并返回数据
      case "callFlutter":
        setState(() {
          content = call.arguments.toString();
          print("终于搞定，让人头疼的狗逼 $content");
        });
        result = "收到来自Android的消息";
        break;
    }
    return result;
  }

}

NewModel newModelFromJson(String str) => NewModel.fromJson(json.decode(str));
String newModelToJson(NewModel data) => json.encode(data.toJson());

class NewModel {

  NewModel({
    this.id,
    this.title,
});
  int id;
  String title;

  factory NewModel.fromJson(Map<String,dynamic> json) => NewModel(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"]
  );
  Map<String,dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title
  };

}

class _DialogComponent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop()=>new Future.value(false);
    return WillPopScope(
      onWillPop:_onWillPop,
      child: Dialog(
        child: new Container(
            height: 64.0,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "努力加载中",
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                ),
                new Container(
                  width: 10.0,
                  height: 1.0,
                ),
                new CircularProgressIndicator(),
              ],
            )),
      ),
    );
  }
}