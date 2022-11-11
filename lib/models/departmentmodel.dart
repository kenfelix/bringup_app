// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Department {
  int pk;
  String url;
  int member;
  String name;
  String status;
  Department({
    required this.pk,
    required this.url,
    required this.member,
    required this.name,
    required this.status,
  });

  Department copyWith({
    int? pk,
    String? url,
    int? member,
    String? name,
    String? status,
  }) {
    return Department(
      pk: pk ?? this.pk,
      url: url ?? this.url,
      member: member ?? this.member,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pk': pk,
      'url': url,
      'member': member,
      'name': name,
      'status': status,
    };
  }

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      pk: map['pk'] as int,
      url: map['url'] as String,
      member: map['member'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Department.fromJson(String source) =>
      Department.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Department(pk: $pk, url: $url, member: $member, name: $name, status: $status)';
  }

  @override
  bool operator ==(covariant Department other) {
    if (identical(this, other)) return true;

    return other.pk == pk &&
        other.url == url &&
        other.member == member &&
        other.name == name &&
        other.status == status;
  }

  @override
  int get hashCode {
    return pk.hashCode ^
        url.hashCode ^
        member.hashCode ^
        name.hashCode ^
        status.hashCode;
  }
}
