import 'package:livestock_repository/livestock_repository.dart';

abstract class LivestockRepository {
  Future<void> addLivestock(Livestock livestock);
  Future<void> deleteLivestock(Livestock livestock);
  Stream<List<Livestock>> livestocks(String userId);
  Future<void> updateLivestock(Livestock livestock);
  Future<List<Livestock>> getLivestock(String id);
}
