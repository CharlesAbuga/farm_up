import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Quantity {
  final double amount;
  final DateTime dateAdded;

  Map<String, dynamic> toDocument() {
    return {
      'amount': amount,
      'dateAdded':
          dateAdded.toIso8601String(), // Convert DateTime to string for storage
    };
  }

  static Quantity fromDocument(Map<String, dynamic> doc) {
    return Quantity(
      amount: doc['amount'],
      dateAdded: DateTime.parse(doc['dateAdded']), // Convert string to DateTime
    );
  }

  Quantity({required this.amount, required this.dateAdded});
}

class FeedingTime {
  final DateTime time;
  final String feedName;

  FeedingTime({required this.time, required this.feedName});
  FeedingTime copyWith({
    String? feedName,
    DateTime? time,
  }) {
    return FeedingTime(
      feedName: feedName ?? this.feedName,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'time': time.toIso8601String(), // Convert DateTime to string for storage
      'feedName': feedName,
    };
  }

  static FeedingTime fromDocument(Map<String, dynamic> doc) {
    return FeedingTime(
      time: DateTime.parse(doc['time']), // Convert string to DateTime
      feedName: doc['feedName'],
    );
  }
}

class Vaccination {
  final String name;
  final DateTime date;
  bool isVaccinated;
  final String? description;

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'date': date.toIso8601String(),
      'description': description,
      'isVaccinated': isVaccinated,
      // Convert DateTime to string for storage
    };
  }

  static Vaccination fromDocument(Map<String, dynamic> doc) {
    return Vaccination(
      name: doc['name'],
      date: DateTime.parse(doc['date']), // Convert string to DateTime
      description: doc['description'],
      isVaccinated: doc['isVaccinated'] ?? false,
    );
  }

  Vaccination(
      {required this.name,
      required this.date,
      required this.description,
      this.isVaccinated = false});
}

class LivestockEntity extends Equatable {
  final String id;
  final String userId;
  final String type;
  final DateTime birthDate;
  final String name;
  final String gender;
  final String breed;
  final List<Vaccination>? vaccinations;
  final List<Quantity>? quantity;
  final List<FeedingTime>? feedingTimes;
  final List<String>? images;
  const LivestockEntity({
    required this.vaccinations,
    required this.type,
    required this.birthDate,
    required this.userId,
    required this.id,
    required this.name,
    required this.breed,
    required this.quantity,
    required this.gender,
    this.feedingTimes,
    this.images,
  });

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'birthDate': birthDate,
      'name': name,
      'breed': breed,
      'gender': gender,
      'vaccinations': vaccinations?.map((e) => e.toDocument()).toList(),
      'feedingTimes': feedingTimes?.map((e) => e.toDocument()).toList(),
      'quantity': quantity?.map((e) => e.toDocument()).toList(),
      'images': images,
    };
  }

  static LivestockEntity fromDocument(Map<String, dynamic> doc) {
    return LivestockEntity(
      id: doc['id'],
      userId: doc['userId'],
      type: doc['type'],
      birthDate: (doc['birthDate'] as Timestamp).toDate(),
      name: doc['name'],
      breed: doc['breed'],
      gender: doc['gender'],
      vaccinations: (doc['vaccinations'] as List<dynamic>?)
          ?.map((e) => Vaccination.fromDocument(e))
          .toList(),
      quantity: (doc['quantity'] as List<dynamic>?)
          ?.map((e) => Quantity.fromDocument(e))
          .toList(),
      feedingTimes: (doc['feedingTimes'] as List<dynamic>?)
          ?.map((e) => FeedingTime.fromDocument(e))
          .toList(),
      images:
          doc['images'] != null ? (doc['images'] as List).cast<String>() : [],
    );
  }

  @override
  List<Object?> get props =>
      [id, userId, type, birthDate, name, breed, feedingTimes];
}
