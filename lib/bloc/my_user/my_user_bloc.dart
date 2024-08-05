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
  StreamSubscription<List<MyUser>>? _myUsersSubscription;

  MyUserBloc({required UserRepository myUserRepository})
      : _userRepository = myUserRepository,
        super(const MyUserState.loading()) {
    on<GetMyUser>((event, emit) async {
      await _fetchUserData(event.myUserId);
    });

    on<GetMyUsers>((event, emit) async {
      await _fetchAllUsers();
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
      log(e.toString());
      log(e.toString());
      emit(const MyUserState.failure());
    }
  }

  Future<void> _fetchAllUsers() async {
    emit(MyUserState.loading());
    try {
      final myUsersStream = _userRepository.getAllUsers();
      _myUsersSubscription = myUsersStream.listen((myUsers) {
        emit(MyUserState.successAllUsers(myUsers));
      }, onError: (e) {
        print(e);
        log(e.toString());
        emit(const MyUserState.failure());
      });
    } on FirebaseException catch (e) {
      print(e.toString());
      log(e.toString());
      emit(const MyUserState.failure());
    }
  }

  @override
  Future<void> close() {
    _myUserSubscription?.cancel();
    _myUsersSubscription?.cancel();
    return super.close();
  }
}
