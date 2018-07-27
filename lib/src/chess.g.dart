// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chess.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Piece _$PieceFromJson(Map<String, dynamic> json) {
  return $checkedNew('Piece', json, () {
    var val = new Piece(
        type: $checkedConvert(
            json, 'type', (v) => v == null ? null : new PieceType.fromJson(v)),
        color: $checkedConvert(json, 'color',
            (v) => v == null ? null : new ChessColor.fromJson(v as int)));
    return val;
  });
}

Map<String, dynamic> _$PieceToJson(Piece instance) => <String, dynamic>{
      'type': instance.type?.toJson(),
      'color': instance.color?.toJson()
    };

Move _$MoveFromJson(Map<String, dynamic> json) {
  return $checkedNew('Move', json, () {
    var val = new Move(
        color: $checkedConvert(json, 'color',
            (v) => v == null ? null : new ChessColor.fromJson(v as int)),
        from: $checkedConvert(json, 'from', (v) => v as int),
        to: $checkedConvert(json, 'to', (v) => v as int),
        flags: $checkedConvert(json, 'flags', (v) => v as int),
        piece: $checkedConvert(
            json, 'piece', (v) => v == null ? null : new PieceType.fromJson(v)),
        captured: $checkedConvert(json, 'captured',
            (v) => v == null ? null : new PieceType.fromJson(v)),
        promotion: $checkedConvert(json, 'promotion',
            (v) => v == null ? null : new PieceType.fromJson(v)));
    return val;
  });
}

Map<String, dynamic> _$MoveToJson(Move instance) => <String, dynamic>{
      'color': instance.color?.toJson(),
      'from': instance.from,
      'to': instance.to,
      'flags': instance.flags,
      'piece': instance.piece?.toJson(),
      'captured': instance.captured?.toJson(),
      'promotion': instance.promotion?.toJson()
    };
