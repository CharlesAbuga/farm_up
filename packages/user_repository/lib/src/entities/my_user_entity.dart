import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final int? phone;
  final String? county;
  final List<Map<String, dynamic>>? livestock;
  final bool? isVet;
  final String? nationalId;
  final List<String>? vetInformation;
  final List<Map<String, String>>? newsArticles;

  const MyUserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.livestock,
    this.county,
    this.phone,
    this.isVet,
    this.vetInformation,
    this.newsArticles,
    this.nationalId,
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
      'newsArticles': newsArticles,
      'nationalId': nationalId,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      id: doc['id'],
      email: doc['email'],
      name: doc['name'],
      phone: doc['phone'],
      county: doc['county'],
      nationalId: doc['nationalId'],
      livestock:
          (doc['livestock'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
      isVet: doc['isVet'],
      newsArticles: (doc['newsArticles'] as List<dynamic>?)
          ?.map((item) => Map<String, String>.from(item))
          .toList(),
      vetInformation: doc['vetInformation'] != null
          ? (doc['vetInformation'] as List).cast<String>()
          : [],
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phone,
        county,
        livestock,
        isVet,
        vetInformation,
        newsArticles,
        nationalId,
      ];

  @override
  String toString() {
    return '''MyUserEntity { id: $id, email: $email, name: $name , phone: $phone, livestock: $livestock, county: $county, isVet: $isVet, vetInformation: $vetInformation, newsArticles: $newsArticles, nationalId: $nationalId }''';
  }
}
