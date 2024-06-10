import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final List<Map<String, dynamic>>? livestock;

  const MyUserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.livestock,
  });
  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'livestock': livestock,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
        id: doc['id'],
        email: doc['email'],
        name: doc['name'],
        livestock:
            (doc['livestock'] as List<dynamic>?)?.cast<Map<String, dynamic>>());
  }

  @override
  List<Object?> get props => [id, email, name];

  String toString() {
    return '''MyUserEntity { id: $id, email: $email, name: $name }''';
  }
}
