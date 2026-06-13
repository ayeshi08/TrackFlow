import 'package:hive/hive.dart';

part 'lat_lng_point.g.dart';  // MUST match this filename exactly

@HiveType(typeId: 1)
class LatLngPoint extends HiveObject {
  @HiveField(0)
  double lat;

  @HiveField(1)
  double lng;

  LatLngPoint({required this.lat, required this.lng});
}