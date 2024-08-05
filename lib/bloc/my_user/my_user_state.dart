part of 'my_user_bloc.dart';

enum MyUserStatus { success, loading, failure, successAllUsers }

class MyUserState extends Equatable {
  final MyUserStatus status;
  final MyUser? user;
  final List<MyUser>? users;

  const MyUserState._(
      {this.status = MyUserStatus.loading, this.user, this.users});

  const MyUserState.loading() : this._();

  const MyUserState.success(MyUser user)
      : this._(status: MyUserStatus.success, user: user);

  const MyUserState.successAllUsers(List<MyUser> users)
      : this._(status: MyUserStatus.successAllUsers, users: users);

  const MyUserState.failure() : this._(status: MyUserStatus.failure);

  @override
  List<Object?> get props => [status, user];
}
