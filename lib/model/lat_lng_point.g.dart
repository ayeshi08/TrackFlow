part of 'lat_lng_point.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LatLngPointAdapter extends TypeAdapter<LatLngPoint> {
  @override
  final int typeId = 1;

  @override
  LatLngPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LatLngPoint(lat: fields[0] as double, lng: fields[1] as double);
  }

  @override
  void write(BinaryWriter writer, LatLngPoint obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.lng);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLngPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
