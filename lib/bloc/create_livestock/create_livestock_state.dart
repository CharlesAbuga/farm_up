part of 'create_livestock_bloc.dart';

sealed class CreateLivestockState extends Equatable {
  const CreateLivestockState();

  @override
  List<Object> get props => [];
}

final class CreateLivestockInitial extends CreateLivestockState {}

final class CreateLivestockLoading extends CreateLivestockState {}

final class CreateLivestockSuccess extends CreateLivestockState {
  final Livestock livestock;
  const CreateLivestockSuccess(this.livestock);
  @override
  List<Object> get props => [livestock];
}

final class CreateLivestockFailure extends CreateLivestockState {}
