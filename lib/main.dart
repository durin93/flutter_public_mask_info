import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:publicmaskinfo/model/store.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final stores = List<Store>();
  var isLoaded;

  Future fetch() async {
    setState(() {
      isLoaded = false;
    });

    final url =
        'https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByGeo/json';
    final response = await http.get(url);
    print(
        'Response status: ${response.statusCode}, ${utf8.decode(response.bodyBytes)}');
    final jsonResult = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      stores.clear();
      jsonResult['stores'].forEach((e) {
        stores.add(Store.fromJson(e));
      });
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('마스크 재고 있는 곳 : ${stores
              .where((e) => e.remainStat == 'plenty' || e.remainStat
              == 'some' || e.remainStat == 'few').length}곳'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: fetch,
            )
          ],
        ),
        body: getMaskInfoWidget());
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('정보를 가져오고 있단다.'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget getMaskInfoWidget() {
    if (isLoaded) {
      return ListView(
        children: stores
            .where((e) => e.remainStat == 'plenty' || e.remainStat
         == 'some' || e.remainStat == 'few')
            .map((e){
              return ListTile(
                title: Text(e.name),
                subtitle: Text(e.addr),
                trailing: _buildRemainStatWidget(e),
              );
            }).toList(),
      );
    }

    return loadingWidget();
  }

  Widget _buildRemainStatWidget(Store store) {
    var remainStat = '판매중지';
    var description = '판매중지';
    var color = Colors.black;

    switch (store.remainStat) {
      case 'plenty':
        remainStat = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some':
      remainStat = '보통';
      description = '30 ~ 100개';
      color = Colors.yellow;
        break;
      case 'few':
      remainStat = '부족';
      description = '2 ~ 30개';
      color = Colors.red;
        break;
      case 'empty':
      remainStat = '매진임박';
      description = '1개 이하';
      color = Colors.grey;
        break;
      default:
    }

    return Column(
      children: <Widget>[
        Text(
          remainStat,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          description,
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
