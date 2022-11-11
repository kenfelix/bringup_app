// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Attendance {
  String title;
  String date;
  int member;
  Attendance({
    required this.title,
    required this.date,
    required this.member,
  });

  Attendance copyWith({
    String? title,
    String? date,
    int? member,
  }) {
    return Attendance(
      title: title ?? this.title,
      date: date ?? this.date,
      member: member ?? this.member,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'date': date,
      'member': member,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      title: map['title'] as String,
      date: map['date'] as String,
      member: map['member'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Attendance.fromJson(String source) =>
      Attendance.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Attendance(title: $title, date: $date, member: $member)';

  @override
  bool operator ==(covariant Attendance other) {
    if (identical(this, other)) return true;

    return other.title == title && other.date == date && other.member == member;
  }

  @override
  int get hashCode => title.hashCode ^ date.hashCode ^ member.hashCode;
}
