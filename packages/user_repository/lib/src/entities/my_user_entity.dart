import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String name;

  const MyUserEntity({
    required this.id,
    required this.email,
    required this.name,
  });
  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      id: doc['id'],
      email: doc['email'],
      name: doc['name'],
    );
  }

  @override
  List<Object?> get props => [id, email, name];

  String toString() {
    return '''MyUserEntity { id: $id, email: $email, name: $name }''';
  }
}
