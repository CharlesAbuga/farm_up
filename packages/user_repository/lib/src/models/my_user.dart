import 'package:equatable/equatable.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:user_repository/src/entities/entities.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  final int? phone;
  final List<Map<String, dynamic>>? livestock;

  const MyUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.livestock,
  });

  static const empty =
      MyUser(id: '', email: '', name: '', livestock: [], phone: 0);
  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    int? phone,
    List<Map<String, dynamic>>? livestock,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      livestock: livestock ?? this.livestock,
      phone: phone ?? this.phone,
    );
  }

  bool get isEmpty => this == MyUser.empty;

  bool get isNotEmpty => this != MyUser.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(
        id: id, email: email, name: name, livestock: livestock, phone: phone);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      livestock: entity.livestock,
      phone: entity.phone,
    );
  }

  @override
  List<Object?> get props => [id, name, email, livestock, phone];
}
