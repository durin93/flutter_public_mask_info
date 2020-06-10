import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:publicmaskinfo/model/store.dart';

class StoreRepository {

  final _distance = Distance();

  Future<List<Store>> fetch(double lat, double lng) async {
    final stores = List<Store>();

    final url =
        'https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByGeo/json?lat=$lat&lng=$lng&m=5000';

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(
            'Response status: ${response.statusCode}, ${utf8.decode(
                response.bodyBytes)}');
        final jsonResult = jsonDecode(utf8.decode(response.bodyBytes));

        jsonResult['stores'].forEach((e) {
          final store = Store.fromJson(e);

          final meter = _distance(
              new LatLng(store.lat, store.lng),
              new LatLng(lat, lng)
          );

          store.meter = meter;

          stores.add(store);
        });

        print('패치 완료');
        return stores.where((e) =>
        e.remainStat == 'plenty' ||
            e.remainStat == 'some' ||
            e.remainStat == 'few').toList()
          ..sort((a, b) => a.meter.compareTo(b.meter));
      }
      return [];
    } catch(e) {
      return [];
    }
  }
}
