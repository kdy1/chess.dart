// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chess.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Piece _$PieceFromJson(Map<String, dynamic> json) {
  return new Piece(
      type: json['type'] == null ? null : new PieceType.fromJson(json['type']),
      color: json['color'] == null
          ? null
          : new ChessColor.fromJson(json['color'] as int));
}

abstract class _$PieceSerializerMixin {
  PieceType get type;
  ChessColor get color;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'type': type, 'color': color};
}

Move _$MoveFromJson(Map<String, dynamic> json) {
  return new Move(
      color: json['color'] == null
          ? null
          : new ChessColor.fromJson(json['color'] as int),
      from: json['from'] as int,
      to: json['to'] as int,
      flags: json['flags'] as int,
      piece:
          json['piece'] == null ? null : new PieceType.fromJson(json['piece']),
      captured: json['captured'] == null
          ? null
          : new PieceType.fromJson(json['captured']),
      promotion: json['promotion'] == null
          ? null
          : new PieceType.fromJson(json['promotion']));
}

abstract class _$MoveSerializerMixin {
  ChessColor get color;
  int get from;
  int get to;
  int get flags;
  PieceType get piece;
  PieceType get captured;
  PieceType get promotion;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'color': color,
        'from': from,
        'to': to,
        'flags': flags,
        'piece': piece,
        'captured': captured,
        'promotion': promotion
      };
}
