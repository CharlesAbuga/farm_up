import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:livestock_repository/src/livestock_repo.dart';
import 'package:livestock_repository/src/models/livestock.dart';
import 'package:uuid/uuid.dart';

class FirebaseLivestockRepository implements LivestockRepository {
  final liveStockCollection =
      FirebaseFirestore.instance.collection('livestocks');

  @override
  Future<Livestock> addLivestock(Livestock livestock) async {
    try {
      livestock.id = const Uuid().v1();
      await liveStockCollection
          .doc(livestock.id)
          .set(livestock.toEntity().toDocument());
      return livestock;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteLivestock(Livestock livestock) {
    return liveStockCollection.doc(livestock.id).delete();
  }

  @override
  Stream<List<Livestock>> livestocks(String userId) {
    try {
      return liveStockCollection
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) =>
                Livestock.fromEntity(LivestockEntity.fromDocument(doc.data())))
            .toList();
      });
    } on FirebaseException catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateLivestock(Livestock livestock) {
    try {
      return liveStockCollection
          .doc(livestock.id)
          .update(livestock.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Livestock>> getLivestock(String id) {
    try {
      return liveStockCollection.where('id', isEqualTo: id).get().then(
          (value) => value.docs
              .map((doc) => Livestock.fromEntity(
                  LivestockEntity.fromDocument(doc.data())))
              .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
