part of 'google_sign_in_bloc.dart';

abstract class GoogleSignInEvent extends Equatable {
  const GoogleSignInEvent();

  @override
  List<Object> get props => [];
}

class GoogleSignInRequired extends GoogleSignInEvent {}
