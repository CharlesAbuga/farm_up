import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:user_repository/src/entities/entities.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  final int? phone;
  final String? county;
  final List<Map<String, dynamic>>? livestock;
  final bool? isVet;
  final List<String>? vetInformation;

  const MyUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.county,
    this.livestock,
    this.isVet = false,
    this.vetInformation,
  });

  static const empty = MyUser(
      id: '',
      email: '',
      name: '',
      livestock: [],
      phone: 0,
      county: '',
      isVet: false,
      vetInformation: []);
  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    int? phone,
    String? county,
    List<Map<String, dynamic>>? livestock,
    bool isVet = false,
    List<String>? vetInformation,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      livestock: livestock ?? this.livestock,
      phone: phone ?? this.phone,
      county: county ?? this.county,
      isVet: isVet,
      vetInformation: vetInformation ?? this.vetInformation,
    );
  }

  bool get isEmpty => this == MyUser.empty;

  bool get isNotEmpty => this != MyUser.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(
        id: id,
        email: email,
        name: name,
        livestock: livestock,
        phone: phone,
        isVet: isVet,
        county: county,
        vetInformation: vetInformation);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      livestock: entity.livestock,
      phone: entity.phone,
      isVet: entity.isVet,
      county: entity.county,
      vetInformation: entity.vetInformation,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, email, livestock, phone, county, isVet, vetInformation];
}
