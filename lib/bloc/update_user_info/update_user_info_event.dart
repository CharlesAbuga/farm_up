part of 'update_user_info_bloc.dart';

sealed class UpdateUserInfoEvent extends Equatable {
  const UpdateUserInfoEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserInfoRequired extends UpdateUserInfoEvent {
  final MyUser user;

  const UpdateUserInfoRequired(this.user);
}
