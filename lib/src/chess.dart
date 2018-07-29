import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

part 'package:chess/src/chess.g.dart';

/*  Copyright (c) 2014, David Kopec (my first name at oaksnow dot com)
 *  Released under the MIT license
 *  https://github.com/davecom/chess.dart/blob/master/LICENSE
 *
 *  Based on chess.js
 *  Copyright (c) 2013, Jeff Hlywa (jhlywa@gmail.com)
 *  Released under the BSD license
 *  https://github.com/jhlywa/chess.js/blob/master/LICENSE
 */
const ChessColor black = ChessColor.black;
const ChessColor white = ChessColor.white;

class Chess {
  static const int EMPTY = -1;

  static const String SYMBOLS = 'pnbrqkPNBRQK';

  static const String DEFAULT_POSITION =
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  static const List<String> POSSIBLE_RESULTS = const [
    '1-0',
    '0-1',
    '1/2-1/2',
    '*'
  ];

  static const Map<ChessColor, List> PAWN_OFFSETS = const {
    black: const [16, 32, 17, 15],
    white: const [-16, -32, -17, -15]
  };

  static const Map<PieceType, List> PIECE_OFFSETS = const {
    PieceType.knight: const [-18, -33, -31, -14, 18, 33, 31, 14],
    PieceType.bishop: const [-17, -15, 17, 15],
    PieceType.rook: const [-16, 1, 16, -1],
    PieceType.queen: const [-17, -16, -15, 1, 17, 16, 15, -1],
    PieceType.king: const [-17, -16, -15, 1, 17, 16, 15, -1]
  };

  static const List ATTACKS = const [
    20,
    0,
    0,
    0,
    0,
    0,
    0,
    24,
    0,
    0,
    0,
    0,
    0,
    0,
    20,
    0,
    0,
    20,
    0,
    0,
    0,
    0,
    0,
    24,
    0,
    0,
    0,
    0,
    0,
    20,
    0,
    0,
    0,
    0,
    20,
    0,
    0,
    0,
    0,
    24,
    0,
    0,
    0,
    0,
    20,
    0,
    0,
    0,
    0,
    0,
    0,
    20,
    0,
    0,
    0,
    24,
    0,
    0,
    0,
    20,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    20,
    0,
    0,
    24,
    0,
    0,
    20,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    20,
    2,
    24,
    2,
    20,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    2,
    53,
    56,
    53,
    2,
    0,
    0,
    0,
    0,
    0,
    0,
    24,
    24,
    24,
    24,
    24,
    24,
    56,
    0,
    56,
    24,
    24,
    24,
    24,
    24,
    24,
    0,
    0,
    0,
    0,
    0,
    0,
    2,
    53,
    56,
    53,
    2,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    20,
    2,
    24,
    2,
    20,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    20,
    0,
    0,
    24,
    0,
    0,
    20,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    20,
    0,
    0,
    0,
    24,
    0,
    0,
    0,
    20,
    0,
    0,
    0,
    0,
    0,
    0,
    20,
    0,
    0,
    0,
    0,
    24,
    0,
    0,
    0,
    0,
    20,
    0,
    0,
    0,
    0,
    20,
    0,
    0,
    0,
    0,
    0,
    24,
    0,
    0,
    0,
    0,
    0,
    20,
    0,
    0,
    20,
    0,
    0,
    0,
    0,
    0,
    0,
    24,
    0,
    0,
    0,
    0,
    0,
    0,
    20
  ];

  static const List RAYS = const [
    17,
    0,
    0,
    0,
    0,
    0,
    0,
    16,
    0,
    0,
    0,
    0,
    0,
    0,
    15,
    0,
    0,
    17,
    0,
    0,
    0,
    0,
    0,
    16,
    0,
    0,
    0,
    0,
    0,
    15,
    0,
    0,
    0,
    0,
    17,
    0,
    0,
    0,
    0,
    16,
    0,
    0,
    0,
    0,
    15,
    0,
    0,
    0,
    0,
    0,
    0,
    17,
    0,
    0,
    0,
    16,
    0,
    0,
    0,
    15,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    17,
    0,
    0,
    16,
    0,
    0,
    15,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    17,
    0,
    16,
    0,
    15,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    17,
    16,
    15,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    0,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    -15,
    -16,
    -17,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    -15,
    0,
    -16,
    0,
    -17,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    -15,
    0,
    0,
    -16,
    0,
    0,
    -17,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    -15,
    0,
    0,
    0,
    -16,
    0,
    0,
    0,
    -17,
    0,
    0,
    0,
    0,
    0,
    0,
    -15,
    0,
    0,
    0,
    0,
    -16,
    0,
    0,
    0,
    0,
    -17,
    0,
    0,
    0,
    0,
    -15,
    0,
    0,
    0,
    0,
    0,
    -16,
    0,
    0,
    0,
    0,
    0,
    -17,
    0,
    0,
    -15,
    0,
    0,
    0,
    0,
    0,
    0,
    -16,
    0,
    0,
    0,
    0,
    0,
    0,
    -17
  ];

  static const Map<String, String> FLAGS = const {
    'NORMAL': 'n',
    'CAPTURE': 'c',
    'BIG_PAWN': 'b',
    'EP_CAPTURE': 'e',
    'PROMOTION': 'p',
    'KSIDE_CASTLE': 'k',
    'QSIDE_CASTLE': 'q'
  };

  static const Map<String, int> BITS = const {
    'NORMAL': BITS_NORMAL,
    'CAPTURE': BITS_CAPTURE,
    'BIG_PAWN': BITS_BIG_PAWN,
    'EP_CAPTURE': BITS_EP_CAPTURE,
    'PROMOTION': BITS_PROMOTION,
    'KSIDE_CASTLE': BITS_KSIDE_CASTLE,
    'QSIDE_CASTLE': BITS_QSIDE_CASTLE
  };

  static const int BITS_NORMAL = 1;
  static const int BITS_CAPTURE = 2;
  static const int BITS_BIG_PAWN = 4;
  static const int BITS_EP_CAPTURE = 8;
  static const int BITS_PROMOTION = 16;
  static const int BITS_KSIDE_CASTLE = 32;
  static const int BITS_QSIDE_CASTLE = 64;

  static const int RANK_1 = 7;
  static const int RANK_2 = 6;
  static const int RANK_3 = 5;
  static const int RANK_4 = 4;
  static const int RANK_5 = 3;
  static const int RANK_6 = 2;
  static const int RANK_7 = 1;
  static const int RANK_8 = 0;

  static const Map SQUARES = const {
    'a8': 0,
    'b8': 1,
    'c8': 2,
    'd8': 3,
    'e8': 4,
    'f8': 5,
    'g8': 6,
    'h8': 7,
    'a7': 16,
    'b7': 17,
    'c7': 18,
    'd7': 19,
    'e7': 20,
    'f7': 21,
    'g7': 22,
    'h7': 23,
    'a6': 32,
    'b6': 33,
    'c6': 34,
    'd6': 35,
    'e6': 36,
    'f6': 37,
    'g6': 38,
    'h6': 39,
    'a5': 48,
    'b5': 49,
    'c5': 50,
    'd5': 51,
    'e5': 52,
    'f5': 53,
    'g5': 54,
    'h5': 55,
    'a4': 64,
    'b4': 65,
    'c4': 66,
    'd4': 67,
    'e4': 68,
    'f4': 69,
    'g4': 70,
    'h4': 71,
    'a3': 80,
    'b3': 81,
    'c3': 82,
    'd3': 83,
    'e3': 84,
    'f3': 85,
    'g3': 86,
    'h3': 87,
    'a2': 96,
    'b2': 97,
    'c2': 98,
    'd2': 99,
    'e2': 100,
    'f2': 101,
    'g2': 102,
    'h2': 103,
    'a1': 112,
    'b1': 113,
    'c1': 114,
    'd1': 115,
    'e1': 116,
    'f1': 117,
    'g1': 118,
    'h1': 119
  };

  static const int SQUARES_A1 = 112;
  static const int SQUARES_A8 = 0;
  static const int SQUARES_H1 = 119;
  static const int SQUARES_H8 = 7;

  static final Map<ChessColor, List> ROOKS = {
    white: [
      {'square': SQUARES_A1, 'flag': BITS_QSIDE_CASTLE},
      {'square': SQUARES_H1, 'flag': BITS_KSIDE_CASTLE}
    ],
    black: [
      {'square': SQUARES_A8, 'flag': BITS_QSIDE_CASTLE},
      {'square': SQUARES_H8, 'flag': BITS_KSIDE_CASTLE}
    ]
  };

  // Instance Variables
  List<Piece> board = new List(128);
  ColorMap<int> kings = new ColorMap(EMPTY);
  ChessColor turn = white;
  ColorMap<int> castling = new ColorMap(0);
  int ep_square = EMPTY;
  int half_moves = 0;
  int move_number = 1;
  List<ChessState> history = [];
  Map header = {};

  /// By default start with the standard chess starting position
  Chess() {
    load(DEFAULT_POSITION);
  }

  /// Start with a position from a FEN
  Chess.fromFEN(String fen) {
    load(fen);
  }

  /// Deep copy of the current Chess instance
  Chess copy() {
    return new Chess()
      ..board = new List<Piece>.from(this.board)
      ..kings = new ColorMap<int>.clone(this.kings)
      ..turn = new ChessColor._(this.turn.value)
      ..castling = new ColorMap<int>.clone(this.castling)
      ..ep_square = this.ep_square
      ..half_moves = this.half_moves
      ..move_number = this.move_number
      ..history = new List<ChessState>.from(this.history)
      ..header = new Map.from(this.header);
  }

  /// Reset all of the instance variables
  void clear() {
    board = new List(128);
    kings = new ColorMap(EMPTY);
    turn = white;
    castling = new ColorMap(0);
    ep_square = EMPTY;
    half_moves = 0;
    move_number = 1;
    history = [];
    header = {};
    update_setup(_generateFen());
  }

  /// Go back to the chess starting position
  void reset() {
    load(DEFAULT_POSITION);
  }

  /// Load a position from a FEN String
  void load(String fen) {
    List<String> tokens = fen.split(new RegExp(r"\s+"));
    String position = tokens[0];

    Map validMap = validate_fen(fen);
    if (!validMap["valid"]) {
      throw new Exception(validMap["error"]);
    }

    clear();

    int cellIndex = 0;
    for (int i = 0; i < position.length; i++) {
      final String piece = position[i];

      if (piece == '/') {
        cellIndex += 8;
      } else if (_isDigit(piece)) {
        cellIndex += int.parse(piece);
      } else {
        ChessColor color = (piece == piece.toUpperCase()) ? white : black;
        PieceType type = PieceType._stringToPieceType[piece.toLowerCase()];
        put(new Piece(type: type, color: color), toCellName(cellIndex));
        cellIndex++;
      }
    }

    if (tokens[1] == 'w') {
      turn = white;
    } else {
      assert(tokens[1] == 'b');
      turn = black;
    }

    if (tokens[2].indexOf('K') > -1) {
      castling[white] |= BITS_KSIDE_CASTLE;
    }
    if (tokens[2].indexOf('Q') > -1) {
      castling[white] |= BITS_QSIDE_CASTLE;
    }
    if (tokens[2].indexOf('k') > -1) {
      castling[black] |= BITS_KSIDE_CASTLE;
    }
    if (tokens[2].indexOf('q') > -1) {
      castling[black] |= BITS_QSIDE_CASTLE;
    }

    ep_square = (tokens[3] == '-') ? EMPTY : SQUARES[tokens[3]];
    half_moves = int.parse(tokens[4]);
    move_number = int.parse(tokens[5]);

    update_setup(_generateFen());
  }

  /// Check the formatting of a FEN String is correct
  /// Returns a Map with keys valid, error_number, and error
  static Map validate_fen(fen) {
    const Map<int, String> errors = {
      0: 'No errors.',
      1: 'FEN string must contain six space-delimited fields.',
      2: '6th field (move number) must be a positive integer.',
      3: '5th field (half move counter) must be a non-negative integer.',
      4: '4th field (en-passant square) is invalid.',
      5: '3rd field (castling availability) is invalid.',
      6: '2nd field (side to move) is invalid.',
      7: '1st field (piece positions) does not contain 8 \'/\'-delimited rows.',
      8: '1st field (piece positions) is invalid [consecutive numbers].',
      9: '1st field (piece positions) is invalid [invalid piece].',
      10: '1st field (piece positions) is invalid [row too large].',
    };

    /* 1st criterion: 6 space-seperated fields? */
    List tokens = fen.split(new RegExp(r"\s+"));
    if (tokens.length != 6) {
      return {'valid': false, 'error_number': 1, 'error': errors[1]};
    }

    /* 2nd criterion: move number field is a integer value > 0? */
    int temp = int.tryParse(tokens[5]);
    if (temp != null) {
      if (temp <= 0) {
        return {'valid': false, 'error_number': 2, 'error': errors[2]};
      }
    } else {
      return {'valid': false, 'error_number': 2, 'error': errors[2]};
    }

    /* 3rd criterion: half move counter is an integer >= 0? */
    temp = int.tryParse(tokens[4]);
    if (temp != null) {
      if (temp < 0) {
        return {'valid': false, 'error_number': 3, 'error': errors[3]};
      }
    } else {
      return {'valid': false, 'error_number': 3, 'error': errors[3]};
    }

    /* 4th criterion: 4th field is a valid e.p.-string? */
    RegExp check4 = new RegExp(r"^(-|[abcdefgh][36])$");
    if (check4.firstMatch(tokens[3]) == null) {
      return {'valid': false, 'error_number': 4, 'error': errors[4]};
    }

    /* 5th criterion: 3th field is a valid castle-string? */
    RegExp check5 = new RegExp(r"^(KQ?k?q?|Qk?q?|kq?|q|-)$");
    if (check5.firstMatch(tokens[2]) == null) {
      return {'valid': false, 'error_number': 5, 'error': errors[5]};
    }

    /* 6th criterion: 2nd field is "w" (white) or "b" (black)? */
    RegExp check6 = new RegExp(r"^(w|b)$");
    if (check6.firstMatch(tokens[1]) == null) {
      return {'valid': false, 'error_number': 6, 'error': errors[6]};
    }

    /* 7th criterion: 1st field contains 8 rows? */
    List rows = tokens[0].split('/');
    if (rows.length != 8) {
      return {'valid': false, 'error_number': 7, 'error': errors[7]};
    }

    /* 8th criterion: every row is valid? */
    for (int i = 0; i < rows.length; i++) {
      /* check for right sum of fields AND not two numbers in succession */
      int sum_fields = 0;
      bool previous_was_number = false;

      for (int k = 0; k < rows[i].length; k++) {
        int temp2 = int.tryParse(rows[i][k]);
        if (temp2 != null) {
          if (previous_was_number) {
            return {'valid': false, 'error_number': 8, 'error': errors[8]};
          }
          sum_fields += temp2;
          previous_was_number = true;
        } else {
          RegExp checkOM = new RegExp(r"^[prnbqkPRNBQK]$");
          if (checkOM.firstMatch(rows[i][k]) == null) {
            return {'valid': false, 'error_number': 9, 'error': errors[9]};
          }
          sum_fields += 1;
          previous_was_number = false;
        }
      }

      if (sum_fields != 8) {
        return {'valid': false, 'error_number': 10, 'error': errors[10]};
      }
    }

    /* everything's okay! */
    return {'valid': true, 'error_number': 0, 'error': errors[0]};
  }

  /// Returns a FEN String representing the current position
  String _generateFen() {
    int empty = 0;
    String fen = '';

    for (int i = SQUARES_A8; i <= SQUARES_H1; i++) {
      if (board[i] == null) {
        empty++;
      } else {
        if (empty > 0) {
          fen += empty.toString();
          empty = 0;
        }

        fen += board[i]._toSymbol();
      }

      if (((i + 1) & 0x88) != 0) {
        if (empty > 0) {
          fen += empty.toString();
        }

        if (i != SQUARES_H1) {
          fen += '/';
        }

        empty = 0;
        i += 8;
      }
    }

    String cflags = '';
    if ((castling[white] & BITS_KSIDE_CASTLE) != 0) {
      cflags += 'K';
    }
    if ((castling[white] & BITS_QSIDE_CASTLE) != 0) {
      cflags += 'Q';
    }
    if ((castling[black] & BITS_KSIDE_CASTLE) != 0) {
      cflags += 'k';
    }
    if ((castling[black] & BITS_QSIDE_CASTLE) != 0) {
      cflags += 'q';
    }

    /* do we have an empty castling flag? */
    if (cflags == "") {
      cflags = '-';
    }
    String epflags = (ep_square == EMPTY) ? '-' : toCellName(ep_square);

    return [fen, turn, cflags, epflags, half_moves, move_number].join(' ');
  }

  /// Updates [header] with the List of args and returns it
  Map set_header(args) {
    for (int i = 0; i < args.length; i += 2) {
      if (args[i] is String && args[i + 1] is String) {
        header[args[i]] = args[i + 1];
      }
    }
    return header;
  }

  /// called when the initial board setup is changed with put() or remove().
  /// modifies the SetUp and FEN properties of the header object.  if the FEN is
  /// equal to the default position, the SetUp and FEN are deleted
  /// the setup is only updated if history.length is zero, ie moves haven't been
  /// made.
  void update_setup(String fen) {
    if (history.length > 0) return;

    if (fen != DEFAULT_POSITION) {
      header['SetUp'] = '1';
      header['FEN'] = fen;
    } else {
      header.remove('SetUp');
      header.remove('FEN');
    }
  }

  /// Returns the piece at the square in question or null
  /// if there is none
  Piece get(String square) {
    return board[SQUARES[square]];
  }

  /// Put [piece] on [square]
  bool put(Piece piece, String square) {
    /* check for piece */
    if (SYMBOLS.indexOf(PieceType._pieceTypeToLower[piece.type]) == -1) {
      return false;
    }

    /* check for valid square */
    if (!(SQUARES.containsKey(square))) {
      return false;
    }

    int sq = SQUARES[square];
    board[sq] = piece;
    if (piece.type == PieceType.king) {
      kings[piece.color] = sq;
    }

    update_setup(_generateFen());

    return true;
  }

  /// Removes a piece from a square and returns it,
  /// or null if none is present
  Piece remove(String square) {
    Piece piece = get(square);
    board[SQUARES[square]] = null;
    if (piece != null && piece.type == PieceType.king) {
      kings[piece.color] = EMPTY;
    }

    update_setup(_generateFen());

    return piece;
  }

  Move build_move(List<Piece> board, from, to, flags, [PieceType promotion]) {
    if (promotion != null) {
      flags |= BITS_PROMOTION;
    }

    PieceType captured;
    Piece toPiece = board[to];
    if (toPiece != null) {
      captured = toPiece.type;
    } else if ((flags & BITS_EP_CAPTURE) != 0) {
      captured = PieceType.pawn;
    }

    return new Move(
      color: turn,
      from: from,
      to: to,
      flags: flags,
      piece: board[from].type,
      captured: captured,
      promotion: promotion,
    );
  }

  List<Move> generate_moves([Map options]) {
    add_move(List<Piece> board, List<Move> moves, from, to, flags) {
      /* if pawn promotion */
      if (board[from].type == PieceType.pawn &&
          (rank(to) == RANK_8 || rank(to) == RANK_1)) {
        var pieces = [
          PieceType.queen,
          PieceType.rook,
          PieceType.bishop,
          PieceType.knight
        ];
        for (var i = 0, len = pieces.length; i < len; i++) {
          moves.add(build_move(board, from, to, flags, pieces[i]));
        }
      } else {
        moves.add(build_move(board, from, to, flags));
      }
    }

    List<Move> moves = [];
    ChessColor us = turn;
    ChessColor them = swap_color(us);
    ColorMap<int> second_rank = new ColorMap(0);
    second_rank[black] = RANK_7;
    second_rank[white] = RANK_2;

    var first_sq = SQUARES_A8;
    var last_sq = SQUARES_H1;
    bool single_square = false;

    /* do we want legal moves? */
    var legal = (options != null && options.containsKey('legal'))
        ? options['legal']
        : true;

    /* are we generating moves for a single square? */
    if (options != null && options.containsKey('square')) {
      if (SQUARES.containsKey(options['square'])) {
        first_sq = last_sq = SQUARES[options['square']];
        single_square = true;
      } else {
        /* invalid square */
        return [];
      }
    }

    for (int i = first_sq; i <= last_sq; i++) {
      /* did we run off the end of the board */
      if ((i & 0x88) != 0) {
        i += 7;
        continue;
      }

      Piece piece = board[i];
      if (piece == null || piece.color != us) {
        continue;
      }

      if (piece.type == PieceType.pawn) {
        /* single square, non-capturing */
        int square = i + PAWN_OFFSETS[us][0];
        if (board[square] == null) {
          add_move(board, moves, i, square, BITS_NORMAL);

          /* double square */
          var square2 = i + PAWN_OFFSETS[us][1];
          if (second_rank[us] == rank(i) && board[square2] == null) {
            add_move(board, moves, i, square2, BITS_BIG_PAWN);
          }
        }

        /* pawn captures */
        for (int j = 2; j < 4; j++) {
          int square = i + PAWN_OFFSETS[us][j];
          if ((square & 0x88) != 0) continue;

          if (board[square] != null && board[square].color == them) {
            add_move(board, moves, i, square, BITS_CAPTURE);
          } else if (square == ep_square) {
            add_move(board, moves, i, ep_square, BITS_EP_CAPTURE);
          }
        }
      } else {
        for (int j = 0, len = PIECE_OFFSETS[piece.type].length; j < len; j++) {
          var offset = PIECE_OFFSETS[piece.type][j];
          var square = i;

          while (true) {
            square += offset;
            if ((square & 0x88) != 0) break;

            if (board[square] == null) {
              add_move(board, moves, i, square, BITS_NORMAL);
            } else {
              if (board[square].color == us) {
                break;
              }
              add_move(board, moves, i, square, BITS_CAPTURE);
              break;
            }

            /* break, if knight or king */
            if (piece.type == PieceType.knight || piece.type == PieceType.king)
              break;
          }
        }
      }
    }

    // check for castling if: a) we're generating all moves, or b) we're doing
    // single square move generation on the king's square
    if ((!single_square) || last_sq == kings[us]) {
      /* king-side castling */
      if ((castling[us] & BITS_KSIDE_CASTLE) != 0) {
        var castling_from = kings[us];
        var castling_to = castling_from + 2;

        if (board[castling_from + 1] == null &&
            board[castling_to] == null &&
            !attacked(them, kings[us]) &&
            !attacked(them, castling_from + 1) &&
            !attacked(them, castling_to)) {
          add_move(board, moves, kings[us], castling_to, BITS_KSIDE_CASTLE);
        }
      }

      /* queen-side castling */
      if ((castling[us] & BITS_QSIDE_CASTLE) != 0) {
        var castling_from = kings[us];
        var castling_to = castling_from - 2;

        if (board[castling_from - 1] == null &&
            board[castling_from - 2] == null &&
            board[castling_from - 3] == null &&
            !attacked(them, kings[us]) &&
            !attacked(them, castling_from - 1) &&
            !attacked(them, castling_to)) {
          add_move(board, moves, kings[us], castling_to, BITS_QSIDE_CASTLE);
        }
      }
    }

    /* return all pseudo-legal moves (this includes moves that allow the king
     * to be captured)
     */
    if (!legal) {
      return moves;
    }

    /* filter out illegal moves */
    List<Move> legal_moves = [];
    for (int i = 0, len = moves.length; i < len; i++) {
      make_move(moves[i]);
      if (!king_attacked(us)) {
        legal_moves.add(moves[i]);
      }
      undo_move();
    }

    return legal_moves;
  }

  /// Convert a move from 0x88 coordinates to Standard Algebraic Notation(SAN)
  String move_to_san(Move move) {
    String output = '';
    int flags = move.flags;
    if ((flags & BITS_KSIDE_CASTLE) != 0) {
      output = 'O-O';
    } else if ((flags & BITS_QSIDE_CASTLE) != 0) {
      output = 'O-O-O';
    } else {
      var disambiguator = get_disambiguator(move);

      if (move.piece != PieceType.pawn) {
        output += PieceType._pieceTypeToUpper[move.piece] + disambiguator;
      }

      if ((flags & (BITS_CAPTURE | BITS_EP_CAPTURE)) != 0) {
        if (move.piece == PieceType.pawn) {
          output += (toCellName(move.from))[0];
        }
        output += 'x';
      }

      output += toCellName(move.to);

      if ((flags & BITS_PROMOTION) != 0) {
        output += '=' + PieceType._pieceTypeToUpper[move.promotion];
      }
    }

    make_move(move);
    if (in_check) {
      if (in_checkmate) {
        output += '#';
      } else {
        output += '+';
      }
    }
    undo_move();

    return output;
  }

  bool attacked(ChessColor color, int square) {
    for (int i = SQUARES_A8; i <= SQUARES_H1; i++) {
      /* did we run off the end of the board */
      if ((i & 0x88) != 0) {
        i += 7;
        continue;
      }

      /* if empty square or wrong color */
      Piece piece = board[i];
      if (piece == null || piece.color != color) continue;

      var difference = i - square;
      var index = difference + 119;
      PieceType type = piece.type;

      if ((ATTACKS[index] & (1 << type.shift)) != 0) {
        if (type == PieceType.pawn) {
          if (difference > 0) {
            if (color == white) return true;
          } else {
            if (color == black) return true;
          }
          continue;
        }

        /* if the piece is a knight or a king */
        if (type == PieceType.knight || type == PieceType.king) return true;

        var offset = RAYS[index];
        var j = i + offset;

        var blocked = false;
        while (j != square) {
          if (board[j] != null) {
            blocked = true;
            break;
          }
          j += offset;
        }

        if (!blocked) return true;
      }
    }

    return false;
  }

  bool king_attacked(ChessColor color) {
    return attacked(swap_color(color), kings[color]);
  }

  bool get in_check {
    return king_attacked(turn);
  }

  bool get in_checkmate {
    return in_check && generate_moves().length == 0;
  }

  bool get in_stalemate {
    return !in_check && generate_moves().length == 0;
  }

  bool get insufficient_material {
    Map pieces = {};
    List bishops = [];
    int num_pieces = 0;
    var sq_color = 0;

    for (int i = SQUARES_A8; i <= SQUARES_H1; i++) {
      sq_color = (sq_color + 1) % 2;
      if ((i & 0x88) != 0) {
        i += 7;
        continue;
      }

      var piece = board[i];
      if (piece != null) {
        pieces[piece.type] =
            (pieces.containsKey(piece.type)) ? pieces[piece.type] + 1 : 1;
        if (piece.type == PieceType.bishop) {
          bishops.add(sq_color);
        }
        num_pieces++;
      }
    }

    /* k vs. k */
    if (num_pieces == 2) {
      return true;
    }
    /* k vs. kn .... or .... k vs. kb */
    else if (num_pieces == 3 &&
        (pieces[PieceType.bishop] == 1 || pieces[PieceType.knight] == 1)) {
      return true;
    }
    /* kb vs. kb where any number of bishops are all on the same color */
    else if (pieces.containsKey(PieceType.bishop) &&
        num_pieces == (pieces[PieceType.bishop] + 2)) {
      var sum = 0;
      var len = bishops.length;
      for (int i = 0; i < len; i++) {
        sum += bishops[i];
      }
      if (sum == 0 || sum == len) {
        return true;
      }
    }

    return false;
  }

  bool get in_threefold_repetition {
    /* TODO: while this function is fine for casual use, a better
     * implementation would use a Zobrist key (instead of FEN). the
     * Zobrist key would be maintained in the make_move/undo_move functions,
     * avoiding the costly that we do below.
     */
    List moves = [];
    Map positions = {};
    bool repetition = false;

    while (true) {
      var move = undo_move();
      if (move == null) {
        break;
      }
      moves.add(move);
    }

    while (true) {
      /* remove the last two fields in the FEN string, they're not needed
       * when checking for draw by rep */
      var fen = _generateFen().split(' ').sublist(0, 4).join(' ');

      /* has the position occurred three or move times */
      positions[fen] = (positions.containsKey(fen)) ? positions[fen] + 1 : 1;
      if (positions[fen] >= 3) {
        repetition = true;
      }

      if (moves.length == 0) {
        break;
      }
      make_move(moves.removeLast());
    }

    return repetition;
  }

  void push(Move move) {
    history.add(new ChessState(move, new ColorMap.clone(kings), turn,
        new ColorMap.clone(castling), ep_square, half_moves, move_number));
  }

  make_move(Move move) {
    assert(move.color == turn);
    assert(board[move.from] != null);
    assert(board[move.from].color == turn);

    ChessColor us = turn;
    ChessColor them = swap_color(us);
    push(move);

    board[move.to] = board[move.from];
    board[move.from] = null;

    /* if ep capture, remove the captured pawn */
    if ((move.flags & BITS_EP_CAPTURE) != 0) {
      if (turn == black) {
        board[move.to - 16] = null;
      } else {
        board[move.to + 16] = null;
      }
    }

    /* if pawn promotion, replace with new piece */
    if ((move.flags & BITS_PROMOTION) != 0) {
      board[move.to] = new Piece(type: move.promotion, color: us);
    }

    /* if we moved the king */
    if (board[move.to].type == PieceType.king) {
      kings[board[move.to].color] = move.to;

      /* if we castled, move the rook next to the king */
      if ((move.flags & BITS_KSIDE_CASTLE) != 0) {
        var castling_to = move.to - 1;
        var castling_from = move.to + 1;
        board[castling_to] = board[castling_from];
        board[castling_from] = null;
      } else if ((move.flags & BITS_QSIDE_CASTLE) != 0) {
        var castling_to = move.to + 1;
        var castling_from = move.to - 2;
        board[castling_to] = board[castling_from];
        board[castling_from] = null;
      }

      /* turn off castling */
      castling[us] = 0;
    }

    /* turn off castling if we move a rook */
    if (castling[us] != 0) {
      for (int i = 0, len = ROOKS[us].length; i < len; i++) {
        if (move.from == ROOKS[us][i]['square'] &&
            ((castling[us] & ROOKS[us][i]['flag']) != 0)) {
          castling[us] ^= ROOKS[us][i]['flag'];
          break;
        }
      }
    }

    /* turn off castling if we capture a rook */
    if (castling[them] != 0) {
      for (int i = 0, len = ROOKS[them].length; i < len; i++) {
        if (move.to == ROOKS[them][i]['square'] &&
            ((castling[them] & ROOKS[them][i]['flag']) != 0)) {
          castling[them] ^= ROOKS[them][i]['flag'];
          break;
        }
      }
    }

    /* if big pawn move, update the en passant square */
    if ((move.flags & BITS_BIG_PAWN) != 0) {
      if (turn == black) {
        ep_square = move.to - 16;
      } else {
        ep_square = move.to + 16;
      }
    } else {
      ep_square = EMPTY;
    }

    /* reset the 50 move counter if a pawn is moved or a piece is captured */
    if (move.piece == PieceType.pawn) {
      half_moves = 0;
    } else if ((move.flags & (BITS_CAPTURE | BITS_EP_CAPTURE)) != 0) {
      half_moves = 0;
    } else {
      half_moves++;
    }

    if (turn == black) {
      move_number++;
    }
    turn = swap_color(turn);
  }

  /// Undoes a move and returns it, or null if move history is empty
  Move undo_move() {
    if (history.isEmpty) {
      return null;
    }
    ChessState old = history.removeLast();
    if (old == null) {
      return null;
    }

    Move move = old.move;
    kings = old.kings;
    turn = old.turn;
    castling = old.castling;
    ep_square = old.ep_square;
    half_moves = old.half_moves;
    move_number = old.move_number;

    ChessColor us = turn;
    ChessColor them = swap_color(turn);

    board[move.from] = new Piece(
      type: move.piece,
      color: move.color,
    );

    /// ORIGINAL CODE WAS
    //	board[move.from] = board[move.to];
    //	board[move.from].type = move.piece; // to undo any promotions
    board[move.to] = null;

    if ((move.flags & BITS_CAPTURE) != 0) {
      board[move.to] = new Piece(type: move.captured, color: them);
    } else if ((move.flags & BITS_EP_CAPTURE) != 0) {
      var index;
      if (us == black) {
        index = move.to - 16;
      } else {
        index = move.to + 16;
      }
      board[index] = new Piece(type: PieceType.pawn, color: them);
    }

    if ((move.flags & (BITS_KSIDE_CASTLE | BITS_QSIDE_CASTLE)) != 0) {
      var castling_to, castling_from;
      if ((move.flags & BITS_KSIDE_CASTLE) != 0) {
        castling_to = move.to + 1;
        castling_from = move.to - 1;
      } else if ((move.flags & BITS_QSIDE_CASTLE) != 0) {
        castling_to = move.to - 2;
        castling_from = move.to + 1;
      }

      board[castling_to] = board[castling_from];
      board[castling_from] = null;
    }

    return move;
  }

  /* this function is used to uniquely identify ambiguous moves */
  get_disambiguator(Move move) {
    List<Move> moves = generate_moves();

    var from = move.from;
    var to = move.to;
    var piece = move.piece;

    var ambiguities = 0;
    var same_rank = 0;
    var same_file = 0;

    for (int i = 0, len = moves.length; i < len; i++) {
      var ambig_from = moves[i].from;
      var ambig_to = moves[i].to;
      var ambig_piece = moves[i].piece;

      /* if a move of the same piece type ends on the same to square, we'll
       * need to add a disambiguator to the algebraic notation
       */
      if (piece == ambig_piece && from != ambig_from && to == ambig_to) {
        ambiguities++;

        if (rank(from) == rank(ambig_from)) {
          same_rank++;
        }

        if (file(from) == file(ambig_from)) {
          same_file++;
        }
      }
    }

    if (ambiguities > 0) {
      /* if there exists a similar moving piece on the same rank and file as
       * the move in question, use the square as the disambiguator
       */
      if (same_rank > 0 && same_file > 0) {
        return toCellName(from);
      }
      /* if the moving piece rests on the same file, use the rank symbol as the
       * disambiguator
       */
      else if (same_file > 0) {
        return toCellName(from)[1];
      }
      /* else use the file symbol */
      else {
        return toCellName(from)[0];
      }
    }

    return '';
  }

  /// Returns a String representation of the current position
  /// complete with ascii art
  String get ascii {
    String s = '   +------------------------+\n';
    for (var i = SQUARES_A8; i <= SQUARES_H1; i++) {
      /* display the rank */
      if (file(i) == 0) {
        s += ' ' + '87654321'[rank(i)] + ' |';
      }

      /* empty piece */
      if (board[i] == null) {
        s += ' . ';
      } else {
        s += ' ${board[i]._toSymbol()} ';
      }

      if (((i + 1) & 0x88) != 0) {
        s += '|\n';
        i += 8;
      }
    }
    s += '   +------------------------+\n';
    s += '     a  b  c  d  e  f  g  h\n';

    return s;
  }

  // Utility Functions
  static int rank(int i) {
    return i >> 4;
  }

  static int file(int i) {
    return i & 15;
  }

  static String toCellName(int i) {
    var f = file(i), r = rank(i);
    return 'abcdefgh'.substring(f, f + 1) + '87654321'.substring(r, r + 1);
  }

  static ChessColor swap_color(ChessColor c) {
    return c == white ? black : white;
  }

  static bool _isDigit(String c) {
    return '0123456789'.contains(c);
  }

  /// pretty = external move object
  Map<String, dynamic> make_pretty(Move ugly_move) {
    Map map = {};
    map['san'] = move_to_san(ugly_move);
    map['to'] = toCellName(ugly_move.to);
    map['from'] = toCellName(ugly_move.from);
    map['captured'] = ugly_move.captured;

    var flags = '';
    for (var flag in BITS.keys) {
      if ((BITS[flag] & ugly_move.flags) != 0) {
        flags += FLAGS[flag];
      }
    }
    map['flags'] = flags;

    return map;
  }

  String _trim(String str) {
    return str.replaceAll(new RegExp(r"^\s+|\s+$"), '');
  }

  // debug utility
  @visibleForTesting
  perft(int depth) {
    List<Move> moves = generate_moves({'legal': false});
    var nodes = 0;
    var color = turn;

    for (var i = 0, len = moves.length; i < len; i++) {
      make_move(moves[i]);
      if (!king_attacked(color)) {
        if (depth - 1 > 0) {
          var child_nodes = perft(depth - 1);
          nodes += child_nodes;
        } else {
          nodes++;
        }
      }
      undo_move();
    }

    return nodes;
  }

  //Public APIs

  ///  Returns a list of legals moves from the current position.
  ///  The function takes an optional parameter which controls the
  ///  single-square move generation and verbosity.
  ///
  ///  The piece, captured, and promotion fields contain the lowercase
  ///  representation of the applicable piece.
  ///
  ///  The flags field in verbose mode may contain one or more of the following values:
  ///
  ///  'n' - a non-capture
  ///  'b' - a pawn push of two squares
  ///  'e' - an en passant capture
  ///  'c' - a standard capture
  ///  'p' - a promotion
  ///  'k' - kingside castling
  ///  'q' - queenside castling
  ///  A flag of 'pc' would mean that a pawn captured a piece on the 8th rank and promoted.
  ///
  ///  If "asObjects" is set to true in the options Map, then it returns a List<Move>
  List moves([Map options]) {
    /* The internal representation of a chess move is in 0x88 format, and
       * not meant to be human-readable.  The code below converts the 0x88
       * square coordinates to algebraic coordinates.  It also prunes an
       * unnecessary move keys resulting from a verbose call.
       */

    List<Move> ugly_moves = generate_moves(options);
    if (options != null &&
        options.containsKey('asObjects') &&
        options['asObjects'] == true) {
      return ugly_moves;
    }
    List moves = [];

    for (int i = 0, len = ugly_moves.length; i < len; i++) {
      /* does the user want a full move object (most likely not), or just
         * SAN
         */
      if (options != null &&
          options.containsKey('verbose') &&
          options['verbose'] == true) {
        moves.add(make_pretty(ugly_moves[i]));
      } else {
        moves.add(move_to_san(ugly_moves[i]));
      }
    }

    return moves;
  }

  bool get in_draw {
    return half_moves >= 100 ||
        in_stalemate ||
        insufficient_material ||
        in_threefold_repetition;
  }

  bool get game_over => in_draw || in_checkmate;

  String get fen => _generateFen();

  /// Return the PGN representation of the game thus far
  String pgn([Map options]) {
    /* using the specification from http://www.chessclub.com/help/PGN-spec
       * example for html usage: .pgn({ max_width: 72, newline_char: "<br />" })
       */
    var newline = (options != null &&
            options.containsKey("newline_char") &&
            options["newline_char"] != null)
        ? options['newline_char']
        : '\n';
    var max_width = (options != null &&
            options.containsKey("max_width") &&
            options["max_width"] != null)
        ? options["max_width"]
        : 0;
    var result = [];
    var header_exists = false;

    /* add the PGN header headerrmation */
    for (var i in header.keys) {
      /* TODO: order of enumerated properties in header object is not
         * guaranteed, see ECMA-262 spec (section 12.6.4)
         */
      result.add(
          '[' + i.toString() + ' \"' + header[i].toString() + '\"]' + newline);
      header_exists = true;
    }

    if (header_exists && (history.length != 0)) {
      result.add(newline);
    }

    /* pop all of history onto reversed_history */
    List<Move> reversed_history = [];
    while (history.length > 0) {
      reversed_history.add(undo_move());
    }

    List<String> moves = [];
    String move_string = '';
    int pgn_move_number = 1;

    /* build the list of moves.  a move_string looks like: "3. e3 e6" */
    while (reversed_history.length > 0) {
      Move move = reversed_history.removeLast();

      /* if the position started with black to move, start PGN with 1. ... */
      if (pgn_move_number == 1 && move.color == black) {
        move_string = '1. ...';
        pgn_move_number++;
      } else if (move.color == white) {
        /* store the previous generated move_string if we have one */
        if (move_string.length != 0) {
          moves.add(move_string);
        }
        move_string = pgn_move_number.toString() + '.';
        pgn_move_number++;
      }

      move_string = move_string + ' ' + move_to_san(move);
      make_move(move);
    }

    /* are there any other leftover moves? */
    if (move_string.length != 0) {
      moves.add(move_string);
    }

    /* is there a result? */
    if (header['Result'] != null) {
      moves.add(header['Result']);
    }

    /* history should be back to what is was before we started generating PGN,
       * so join together moves
       */
    if (max_width == 0) {
      return result.join('') + moves.join(' ');
    }

    /* wrap the PGN output at max_width */
    var current_width = 0;
    for (int i = 0; i < moves.length; i++) {
      /* if the current move will push past max_width */
      if (current_width + moves[i].length > max_width && i != 0) {
        /* don't end the line with whitespace */
        if (result[result.length - 1] == ' ') {
          result.removeLast();
        }

        result.add(newline);
        current_width = 0;
      } else if (i != 0) {
        result.add(' ');
        current_width++;
      }
      result.add(moves[i]);
      current_width += moves[i].length;
    }

    return result.join('');
  }

  /// Load the moves of a game stored in Portable Game Notation.
  /// [options] is an optional parameter that contains a 'newline_char'
  /// which is a string representation of a RegExp (and should not be pre-escaped)
  /// and defaults to '\r?\n').
  /// Returns [true] if the PGN was parsed successfully, otherwise [false].
  load_pgn(String pgn, [Map options]) {
    mask(str) {
      return str.replaceAll(new RegExp(r"\\"), '\\');
    }

    /* convert a move from Standard Algebraic Notation (SAN) to 0x88
       * coordinates
      */
    move_from_san(move) {
      var moves = generate_moves();
      for (var i = 0, len = moves.length; i < len; i++) {
        /* strip off any trailing move decorations: e.g Nf3+?! */
        if (move.replaceAll(new RegExp(r"[+#?!=]+$"), '') ==
            move_to_san(moves[i]).replaceAll(new RegExp(r"[+#?!=]+$"), '')) {
          return moves[i];
        }
      }
      return null;
    }

    get_move_obj(move) {
      return move_from_san(_trim(move));
    }

    /*has_keys(object) {
        bool has_keys = false;
        for (var key in object) {
          has_keys = true;
        }
        return has_keys;
      }*/

    parse_pgn_header(header, [Map options]) {
      var newline_char =
          (options != null && options.containsKey("newline_char"))
              ? options['newline_char']
              : '\r?\n';
      var header_obj = {};
      var headers = header.split(newline_char);
      var key = '';
      var value = '';

      for (var i = 0; i < headers.length; i++) {
        RegExp keyMatch = new RegExp(r"^\[([A-Z][A-Za-z]*)\s.*\]$");
        var temp = keyMatch.firstMatch(headers[i]);
        if (temp != null) {
          key = temp[1];
        }
        //print(key);
        RegExp valueMatch = new RegExp(r'^\[[A-Za-z]+\s"(.*)"\]$');
        temp = valueMatch.firstMatch(headers[i]);
        if (temp != null) {
          value = temp[1];
        }
        //print(value);
        if (_trim(key).length > 0) {
          header_obj[key] = value;
        }
      }

      return header_obj;
    }

    var newline_char = (options != null && options.containsKey("newline_char"))
        ? options["newline_char"]
        : '\r?\n';
    //var regex = new RegExp(r'^(\[.*\]).*' + r'1\.'); //+ r"1\."); //+ mask(newline_char));

    int indexOfMoveStart = pgn.indexOf(new RegExp(newline_char + r"1\."));

    /* get header part of the PGN file */
    String header_string = null;
    if (indexOfMoveStart != -1) {
      header_string = pgn.substring(0, indexOfMoveStart).trim();
    }

    /* no info part given, begins with moves */
    if (header_string == null || header_string[0] != '[') {
      header_string = '';
    }

    reset();

    /* parse PGN header */
    var headers = parse_pgn_header(header_string, options);
    for (var key in headers.keys) {
      set_header([key, headers[key]]);
    }

    /* delete header to get the moves */
    var ms = pgn
        .replaceAll(header_string, '')
        .replaceAll(new RegExp(mask(newline_char)), ' ');

    /* delete comments */
    ms = ms.replaceAll(new RegExp(r"(\{[^}]+\})+?"), '');

    /* delete move numbers */
    ms = ms.replaceAll(new RegExp(r"\d+\."), '');

    /* trim and get array of moves */
    var moves = _trim(ms).split(new RegExp(r"\s+"));

    /* delete empty entries */
    moves = moves.join(',').replaceAll(new RegExp(r",,+"), ',').split(',');
    var move;

    for (var half_move = 0; half_move < moves.length - 1; half_move++) {
      move = get_move_obj(moves[half_move]);

      /* move not possible! (don't clear the board to examine to show the
         * latest valid position)
         */
      if (move == null) {
        return false;
      } else {
        make_move(move);
      }
    }

    /* examine last move */
    move = moves[moves.length - 1];
    if (POSSIBLE_RESULTS.contains(move)) {
      if (!header.containsKey("Result")) {
        set_header(['Result', move]);
      }
    } else {
      var moveObj = get_move_obj(move);
      if (moveObj == null) {
        return false;
      } else {
        make_move(moveObj);
      }
    }
    return true;
  }

  /// The move function can be called with in the following parameters:
  /// .move('Nxb7')      <- where 'move' is a case-sensitive SAN string
  /// .move({ from: 'h7', <- where the 'move' is a move object (additional
  ///      to :'h8',      fields are ignored)
  ///      promotion: 'q',
  ///      })
  /// or it can be called with a Move object
  /// It returns true if the move was made, or false if it could not be.
  bool move(Move move) {
    assert(move != null);

    /* need to make a copy of move because we can't generate SAN after the
       * move is made
       */

    make_move(move);

    return true;
  }

  bool moveSan(String san) {
    assert(san != null);

    List<Move> moves = generate_moves();
    /* convert the move string to a move object */
    for (int i = 0; i < moves.length; i++) {
      if (move == move_to_san(moves[i])) {
        // This should return true
        return this.move(moves[i]);
      }
    }

    return false;
  }

  bool moveMap({
    int to,
    int from,
    PieceType promotion,
  }) {
    assert(to != null);
    assert(from != null);
    assert(promotion != null);

    List<Move> moves = generate_moves();
    /* convert the pretty move object to an ugly move object */
    for (var i = 0; i < moves.length; i++) {
      if (from == moves[i].from &&
          to == moves[i].to &&
          (moves[i].promotion == null || promotion == moves[i].promotion)) {
        // This should return true
        return this.move(moves[i]);
      }
    }
    return false;
  }

  /// Takeback the last half-move, returning a move Map if successful, otherwise null.
  Map undo() {
    var move = undo_move();
    return (move != null) ? make_pretty(move) : null;
  }

  /// Returns the color of the square ('light' or 'dark'), or null if [square] is invalid
  String square_color(square) {
    if (SQUARES.containsKey(square)) {
      var sq_0x88 = SQUARES[square];
      return ((rank(sq_0x88) + file(sq_0x88)) % 2 == 0) ? 'light' : 'dark';
    }

    return null;
  }

  getHistory([Map options]) {
    List<Move> reversed_history = [];
    var move_history = [];
    var verbose = (options != null &&
        options.containsKey("verbose") &&
        options["verbose"] == true);

    while (history.length > 0) {
      reversed_history.add(undo_move());
    }

    while (reversed_history.length > 0) {
      Move move = reversed_history.removeLast();
      if (verbose) {
        move_history.add(make_pretty(move));
      } else {
        move_history.add(move_to_san(move));
      }
      make_move(move);
    }

    return move_history;
  }
}

@immutable
@JsonSerializable()
class Piece {
  final PieceType type;
  final ChessColor color;

  Piece({
    @required this.type,
    @required this.color,
  })  : assert(type != null),
        assert(color != null);

  factory Piece.fromJson(Map<String, dynamic> data) => _$PieceFromJson(data);

  Map<String, dynamic> toJson() => _$PieceToJson(this);

  String _toSymbol() {
    return (color == white)
        ? PieceType._pieceTypeToUpper[type]
        : PieceType._pieceTypeToLower[type];
  }

  @override
  bool operator ==(other) =>
      other is Piece && type == other.type && color == other.color;

  @override
  int get hashCode => hash2(type, color);

  @override
  String toString() => _toSymbol();
}

@immutable
@JsonSerializable(
  createFactory: false,
  createToJson: false,
)
class PieceType {
  const PieceType._({
    @required this.shift,
  }) : assert(shift != null);
  final int shift;

  static const pawn = const PieceType._(shift: 0);
  static const knight = const PieceType._(shift: 1);
  static const bishop = const PieceType._(shift: 2);
  static const rook = const PieceType._(shift: 3);
  static const queen = const PieceType._(shift: 4);
  static const king = const PieceType._(shift: 5);

  @override
  int get hashCode => this.shift;

  @override
  String toString() => _pieceTypeToLower[this];

  factory PieceType.fromJson(dynamic v) {
    if (v is int) {
      switch (v) {
        case 0:
          return pawn;
        case 1:
          return knight;
        case 2:
          return bishop;
        case 3:
          return rook;
        case 4:
          return queen;
        case 5:
          return king;
      }
    } else if (v is String) {
      if (_stringToPieceType.containsKey(v)) {
        return _stringToPieceType[v];
      }
    }
    throw new Exception('Unknown piece type $v');
  }

  int toJson() => this.shift;

  static const Map<PieceType, String> _pieceTypeToLower = const {
    PieceType.pawn: 'p',
    PieceType.knight: 'n',
    PieceType.bishop: 'b',
    PieceType.rook: 'r',
    PieceType.queen: 'q',
    PieceType.king: 'k',
  };
  static const Map<PieceType, String> _pieceTypeToUpper = const {
    PieceType.pawn: 'P',
    PieceType.knight: 'N',
    PieceType.bishop: 'B',
    PieceType.rook: 'R',
    PieceType.queen: 'Q',
    PieceType.king: 'K',
  };

  static const Map<String, PieceType> _stringToPieceType = const {
    'p': PieceType.pawn,
    'n': PieceType.knight,
    'b': PieceType.bishop,
    'r': PieceType.rook,
    'q': PieceType.queen,
    'k': PieceType.king
  };
}

@immutable
@JsonSerializable(
  createFactory: false,
  createToJson: false,
)
class ChessColor {
  final int value;

  const ChessColor._(this.value);

  static const ChessColor white = const ChessColor._(0);
  static const ChessColor black = const ChessColor._(1);

  @override
  int get hashCode => value;

  @override
  String toString() => isWhite ? 'w' : 'b';

  bool get isWhite => this == white;

  bool get isBlack => this == black;

  factory ChessColor.fromJson(int value) {
    assert(value == 0 || value == 1, 'invalid chess color $value}');
    return value == 0 ? white : black;
  }

  int toJson() => value;
}

class ColorMap<T> {
  T _white;
  T _black;

  ColorMap(T value)
      : _white = value,
        _black = value;

  ColorMap.clone(ColorMap other)
      : _white = other._white,
        _black = other._black;

  T operator [](ChessColor color) {
    return (color == ChessColor.white) ? _white : _black;
  }

  void operator []=(ChessColor color, T value) {
    if (color == ChessColor.white) {
      _white = value;
    } else {
      _black = value;
    }
  }
}

@immutable
@JsonSerializable(includeIfNull: false)
class Move {
  final ChessColor color;
  final int from;
  final int to;
  final int flags;
  final PieceType piece;
  final PieceType captured;
  final PieceType promotion;

  const Move({
    this.color,
    this.from,
    this.to,
    this.flags,
    this.piece,
    this.captured,
    this.promotion,
  });

  factory Move.fromJson(Map<String, dynamic> data) => _$MoveFromJson(data);

  Map<String, dynamic> toJson() => _$MoveToJson(this);

  @override
  int get hashCode =>
      hashObjects([color, from, to, flags, piece, captured, promotion]);
  @override
  bool operator ==(other) =>
      other is Move &&
      color == other.color &&
      from == other.from &&
      to == other.to &&
      flags == other.flags &&
      piece == other.piece &&
      captured == other.captured &&
      promotion == other.promotion;

  @override
  String toString() {
    if (promotion == null)
      return 'Move(${toCellName(from)} -> ${toCellName(to)})';
    return 'Move(${toCellName(from)} -> ${toCellName(to)}, prootion = $promotion)';
  }
}

class ChessState {
  final Move move;
  final ColorMap<int> kings;
  final ChessColor turn;
  final ColorMap<int> castling;
  final int ep_square;
  final int half_moves;
  final int move_number;

  const ChessState(this.move, this.kings, this.turn, this.castling,
      this.ep_square, this.half_moves, this.move_number);
}

bool isWhite(ChessColor c) => c == white;

/// 인덱스 -> 칸 이름.
String toCellName(int i) {
  const CHARS = 'abcdefghijklmnop';
  return CHARS[i % 16] + (8 - (i ~/ 16)).toString();
}

int cellIndex(String square) {
  return Chess.SQUARES[square];
}
