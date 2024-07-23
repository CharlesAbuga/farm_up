import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final int? phone;
  final String? county;
  final List<Map<String, dynamic>>? livestock;
  final bool? isVet;
  final List<String>? vetInformation;

  const MyUserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.livestock,
    this.county,
    this.phone,
    this.isVet = false,
    this.vetInformation,
  });
  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'livestock': livestock,
      'phone': phone,
      'county': county,
      'isVet': isVet,
      'vetInformation': vetInformation,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      id: doc['id'],
      email: doc['email'],
      name: doc['name'],
      phone: doc['phone'],
      county: doc['county'],
      livestock:
          (doc['livestock'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
      isVet: doc['isVet'],
      vetInformation: doc['vetInformation'] != null
          ? (doc['vetInformation'] as List).cast<String>()
          : [],
    );
  }

  @override
  List<Object?> get props =>
      [id, email, name, phone, county, livestock, isVet, vetInformation];

  String toString() {
    return '''MyUserEntity { id: $id, email: $email, name: $name , phone: $phone, livestock: $livestock, county: $county, isVet: $isVet, vetInformation: $vetInformation}''';
  }
}
