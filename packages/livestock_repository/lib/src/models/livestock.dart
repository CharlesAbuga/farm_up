import 'package:livestock_repository/livestock_repository.dart';

class Livestock {
  String id;
  String userId;
  String type;
  DateTime birthDate;
  String name;
  String breed;
  String gender;
  List<Vaccination>? vaccinations;
  List<Quantity>? quantity;
  Livestock({
    required this.gender,
    this.vaccinations,
    required this.type,
    required this.birthDate,
    required this.userId,
    required this.id,
    required this.name,
    required this.breed,
    this.quantity,
  });
  static var empty = Livestock(
    id: '',
    userId: '',
    type: '',
    birthDate: DateTime.now(),
    name: '',
    breed: '',
    gender: '',
    vaccinations: [],
    quantity: [],
  );

  Livestock copyWith({
    String? id,
    String? userId,
    String? type,
    DateTime? birthDate,
    String? name,
    String? breed,
    String? gender,
    List<Vaccination>? vaccinations,
    List<Quantity>? quantity,
  }) {
    return Livestock(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      birthDate: birthDate ?? this.birthDate,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      breed: breed ?? this.breed,
      vaccinations: vaccinations ?? this.vaccinations,
      quantity: quantity ?? this.quantity,
    );
  }

  bool get isEmpty => this == Livestock.empty;
  bool get isNotEmpty => this != Livestock.empty;

  LivestockEntity toEntity() {
    return LivestockEntity(
      id: id,
      userId: userId,
      type: type,
      birthDate: birthDate,
      name: name,
      breed: breed,
      vaccinations: vaccinations,
      quantity: quantity,
      gender: gender,
    );
  }

  static Livestock fromEntity(LivestockEntity entity) {
    return Livestock(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      birthDate: entity.birthDate,
      name: entity.name,
      breed: entity.breed,
      vaccinations: entity.vaccinations,
      quantity: entity.quantity,
      gender: entity.gender,
    );
  }
}
