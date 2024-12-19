import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'google_sign_in_event.dart';
part 'google_sign_in_state.dart';

class GoogleSignInBloc extends Bloc<GoogleSignInEvent, GoogleSignInState> {
  final UserRepository _userRepository;

  GoogleSignInBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(GoogleSignInInitial()) {
    on<GoogleSignInRequired>((event, emit) async {
      emit(GoogleSignInProcess());
      try {
        await _userRepository.signInWithGoogle();
        emit(GoogleSignInSuccess());
      } catch (e) {
        print(e.toString());
        emit(GoogleSignInFailure());
      }
    });
  }
}
