import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:publicmaskinfo/model/store.dart';
import 'package:publicmaskinfo/repository/location_repository.dart';
import 'package:publicmaskinfo/repository/store_repository.dart';
import 'package:provider/provider.dart';


class StoreModel with ChangeNotifier {
  List<Store> stores = [];
  var isLoaded = false;

  final _storeRepository = StoreRepository();

  final _locationRepository = LocationRepository();

  StoreModel() {
    fetch();
  }

  Future fetch() async {
    isLoaded = false;
    notifyListeners();

    Position position = await _locationRepository.getCurrentLocation();

    stores = await _storeRepository.fetch(
        position.latitude, position.longitude
    );

    isLoaded = true;
    notifyListeners();
  }

}