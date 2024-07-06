import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'my_user_event.dart';
part 'my_user_state.dart';

class MyUserBloc extends Bloc<MyUserEvent, MyUserState> {
  final UserRepository _userRepository;
  StreamSubscription<MyUser>? _myUserSubscription;

  MyUserBloc({required UserRepository myUserRepository})
      : _userRepository = myUserRepository,
        super(const MyUserState.loading()) {
    on<GetMyUser>((event, emit) async {
      await _fetchUserData(event.myUserId);
    });
  }
  Future<void> _fetchUserData(String userId) async {
    emit(MyUserState.loading());
    try {
      final myUserStream = _userRepository.getMyUser(userId);
      _myUserSubscription = myUserStream.listen((myUser) {
        emit(MyUserState.success(myUser));
      }, onError: (e) {
        print(e);
        log(e.toString());
        emit(const MyUserState.failure());
      });
    } on FirebaseException catch (e) {
      print(e.toString());
      print(e.message);
      log(e.toString());
      emit(const MyUserState.failure());
    }
  }

  @override
  Future<void> close() {
    _myUserSubscription?.cancel();
    return super.close();
  }
}
