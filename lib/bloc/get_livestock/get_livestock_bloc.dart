import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livestock_repository/livestock_repository.dart';

part 'get_livestock_event.dart';
part 'get_livestock_state.dart';

class GetLivestockBloc extends Bloc<GetLivestockEvent, GetLivestockState> {
  final LivestockRepository _livestockRepository;
  StreamSubscription? _livestockSubscription;

  GetLivestockBloc({required LivestockRepository livestockRepository})
      : _livestockRepository = livestockRepository,
        super(GetLivestockInitial()) {
    on<GetLivestock>((event, emit) async {
      await _fetchData(event.userId);
    });
  }

  Future<void> _fetchData(String userId) async {
    emit(GetLivestockLoading());
    try {
      // Use the repository method to get the stream
      final livestockStream = _livestockRepository.livestocks(userId);
      _livestockSubscription = livestockStream.listen((livestock) {
        emit(GetLivestockSuccess(livestock));
      }, onError: (e) {
        print(e);
        log(e.toString());
        emit(GetLivestockFailure());
      });
    } on FirebaseException catch (e) {
      // Handle error
      print(e.toString());
      print(e.message);
      log(e.toString());
      emit(GetLivestockFailure());
    }
  }

  @override
  Future<void> close() {
    _livestockSubscription?.cancel();
    return super.close();
  }
}
