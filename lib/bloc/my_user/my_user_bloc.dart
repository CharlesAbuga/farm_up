import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'my_user_event.dart';
part 'my_user_state.dart';

class MyUserBloc extends Bloc<MyUserEvent, MyUserState> {
  final UserRepository _userRepository;

  MyUserBloc({required UserRepository myUserRepository})
      : _userRepository = myUserRepository,
        super(const MyUserState.loading()) {
    on<GetMyUser>((event, emit) async {
      try {
        MyUser myUser = await _userRepository.getMyUser(event.myUserId);
        emit(MyUserState.success(myUser));
      } on FirebaseException catch (e) {
        log(e.toString());
        print(e.message);
        emit(const MyUserState.failure());
      }
    });
  }
}
