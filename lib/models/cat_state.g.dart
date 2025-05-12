// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CatStateAdapter extends TypeAdapter<CatState> {
  @override
  final int typeId = 0;

  @override
  CatState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CatState(
      food: fields[0] as double,
      sleep: fields[1] as double,
      game: fields[2] as double,
      lastUpdated: fields[3] as DateTime,
      isSleeping: fields[4] as bool,
      sleepProgress: fields[5] as double,
      sleepRecoveryRate: fields[6] as double,
      lastClosedTime: fields[7] as DateTime?,
      fishCount: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CatState obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.food)
      ..writeByte(1)
      ..write(obj.sleep)
      ..writeByte(2)
      ..write(obj.game)
      ..writeByte(3)
      ..write(obj.lastUpdated)
      ..writeByte(4)
      ..write(obj.isSleeping)
      ..writeByte(5)
      ..write(obj.sleepProgress)
      ..writeByte(6)
      ..write(obj.sleepRecoveryRate)
      ..writeByte(7)
      ..write(obj.lastClosedTime)
      ..writeByte(8)
      ..write(obj.fishCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
