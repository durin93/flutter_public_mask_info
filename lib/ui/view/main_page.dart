import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publicmaskinfo/model/store.dart';
import 'package:publicmaskinfo/ui/widget/remain_stat_list_tile.dart';
import 'package:publicmaskinfo/viewmodel/store_model.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storeModel = Provider.of<StoreModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('마스크 재고 있는 곳 : ${storeModel.stores.length}곳'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                storeModel.fetch();
              },
            )
          ],
        ),
        body: _getMaskInfoWidget(storeModel));
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

  Widget _getMaskInfoWidget(StoreModel storeModel) {
    print('ona ${storeModel.stores.length}');
    print('ona ${storeModel.isLoaded}');


    if(storeModel.stores.isEmpty){
      return Center(
        child: Text('반경 5km 이내에 재고가 있는 매장이 없습니다.'),
      );
    }

    if (storeModel.isLoaded == true) {
      return ListView(
        children: storeModel.stores.map((store) {
          return RemainStatListTile(store);
        }).toList(),
      );
    }

    return loadingWidget();
  }
}
