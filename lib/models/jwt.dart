// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Token {
  final String refresh;
  final String access;
  Token({
    required this.refresh,
    required this.access,
  });

  Token copyWith({
    String? refresh,
    String? access,
  }) {
    return Token(
      refresh: refresh ?? this.refresh,
      access: access ?? this.access,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'refresh': refresh,
      'access': access,
    };
  }

  factory Token.fromMap(Map<String, dynamic> map) {
    return Token(
      refresh: map['refresh'] as String,
      access: map['access'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Token.fromJson(String source) =>
      Token.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Token(refresh: $refresh, access: $access)';

  @override
  bool operator ==(covariant Token other) {
    if (identical(this, other)) return true;

    return other.refresh == refresh && other.access == access;
  }

  @override
  int get hashCode => refresh.hashCode ^ access.hashCode;
}
