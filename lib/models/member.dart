// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:bringup_app/models/departmentmodel.dart';

class Member {
  int pk;
  String first_name;
  String last_name;
  String phone_number;
  String sex;
  String email;
  String address;
  String date_of_birth;
  String state_of_origin;
  String nationality;
  List<Department> departments;
  bool member_choice;
  String status;
  Member({
    required this.pk,
    required this.first_name,
    required this.last_name,
    required this.phone_number,
    required this.sex,
    required this.email,
    required this.address,
    required this.date_of_birth,
    required this.state_of_origin,
    required this.nationality,
    required this.departments,
    required this.member_choice,
    required this.status,
  });

  Member copyWith({
    int? pk,
    String? first_name,
    String? last_name,
    String? phone_number,
    String? sex,
    String? email,
    String? address,
    String? date_of_birth,
    String? state_of_origin,
    String? nationality,
    List<Department>? departments,
    bool? member_choice,
    String? status,
  }) {
    return Member(
      pk: pk ?? this.pk,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      phone_number: phone_number ?? this.phone_number,
      sex: sex ?? this.sex,
      email: email ?? this.email,
      address: address ?? this.address,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      state_of_origin: state_of_origin ?? this.state_of_origin,
      nationality: nationality ?? this.nationality,
      departments: departments ?? this.departments,
      member_choice: member_choice ?? this.member_choice,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pk': pk,
      'first_name': first_name,
      'last_name': last_name,
      'phone_number': phone_number,
      'sex': sex,
      'email': email,
      'address': address,
      'date_of_birth': date_of_birth,
      'state_of_origin': state_of_origin,
      'nationality': nationality,
      'departments': departments.map((x) => x.toMap()).toList(),
      'member_choice': member_choice,
      'status': status,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      pk: map['pk'] as int,
      first_name: map['first_name'] as String,
      last_name: map['last_name'] as String,
      phone_number: map['phone_number'] as String,
      sex: map['sex'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      date_of_birth: map['date_of_birth'] as String,
      state_of_origin: map['state_of_origin'] as String,
      nationality: map['nationality'] as String,
      departments: List<Department>.from(
        (map['departments'] as List<dynamic>).map<Department>(
          (x) => Department.fromMap(x as Map<String, dynamic>),
        ),
      ),
      member_choice: map['member_choice'] as bool,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) =>
      Member.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Member(pk: $pk, first_name: $first_name, last_name: $last_name, phone_number: $phone_number, sex: $sex, email: $email, address: $address, date_of_birth: $date_of_birth, state_of_origin: $state_of_origin, nationality: $nationality, departments: $departments, member_choice: $member_choice, status: $status)';
  }

  @override
  bool operator ==(covariant Member other) {
    if (identical(this, other)) return true;

    return other.pk == pk &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.phone_number == phone_number &&
        other.sex == sex &&
        other.email == email &&
        other.address == address &&
        other.date_of_birth == date_of_birth &&
        other.state_of_origin == state_of_origin &&
        other.nationality == nationality &&
        listEquals(other.departments, departments) &&
        other.member_choice == member_choice &&
        other.status == status;
  }

  @override
  int get hashCode {
    return pk.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        phone_number.hashCode ^
        sex.hashCode ^
        email.hashCode ^
        address.hashCode ^
        date_of_birth.hashCode ^
        state_of_origin.hashCode ^
        nationality.hashCode ^
        departments.hashCode ^
        member_choice.hashCode ^
        status.hashCode;
  }
}

class Memberlist {
  int pk;
  String url;
  String first_name;
  String last_name;
  String phone_number;
  String status;
  Memberlist({
    required this.pk,
    required this.url,
    required this.first_name,
    required this.last_name,
    required this.phone_number,
    required this.status,
  });

  Memberlist copyWith({
    int? pk,
    String? url,
    String? first_name,
    String? last_name,
    String? phone_number,
    String? status,
  }) {
    return Memberlist(
      pk: pk ?? this.pk,
      url: url ?? this.url,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      phone_number: phone_number ?? this.phone_number,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pk': pk,
      'url': url,
      'first_name': first_name,
      'last_name': last_name,
      'phone_number': phone_number,
      'status': status,
    };
  }

  factory Memberlist.fromMap(Map<String, dynamic> map) {
    return Memberlist(
      pk: map['pk'] as int,
      url: map['url'] as String,
      first_name: map['first_name'] as String,
      last_name: map['last_name'] as String,
      phone_number: map['phone_number'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Memberlist.fromJson(String source) =>
      Memberlist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Memberlist(pk: $pk, url: $url, first_name: $first_name, last_name: $last_name, phone_number: $phone_number, status: $status)';
  }

  @override
  bool operator ==(covariant Memberlist other) {
    if (identical(this, other)) return true;

    return other.pk == pk &&
        other.url == url &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.phone_number == phone_number &&
        other.status == status;
  }

  @override
  int get hashCode {
    return pk.hashCode ^
        url.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        phone_number.hashCode ^
        status.hashCode;
  }
}
