import 'package:equatable/equatable.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:user_repository/src/entities/entities.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  final List<Map<String, dynamic>>? livestock;

  const MyUser({
    required this.id,
    required this.email,
    required this.name,
    this.livestock,
  });

  static const empty = MyUser(id: '', email: '', name: '', livestock: []);
  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    List<Map<String, dynamic>>? livestock,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      livestock: livestock ?? this.livestock,
    );
  }

  bool get isEmpty => this == MyUser.empty;

  bool get isNotEmpty => this != MyUser.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(id: id, email: email, name: name, livestock: livestock);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        id: entity.id,
        email: entity.email,
        name: entity.name,
        livestock: entity.livestock);
  }

  @override
  List<Object?> get props => [id, name, email, livestock];
}
