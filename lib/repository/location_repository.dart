import 'package:geolocator/geolocator.dart';

class LocationRepository {
  final _geolocator = Geolocator();

  Future<Position> getCurrentLocation() async {
    return await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
