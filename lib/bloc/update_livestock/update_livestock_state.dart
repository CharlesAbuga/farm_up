part of 'update_livestock_bloc.dart';

sealed class UpdateLivestockState extends Equatable {
  const UpdateLivestockState();

  @override
  List<Object> get props => [];
}

final class UpdateLivestockInitial extends UpdateLivestockState {}

final class UpdateLivestockLoading extends UpdateLivestockState {}

final class UpdateLivestockSuccess extends UpdateLivestockState {
  final Livestock livestock;

  const UpdateLivestockSuccess(this.livestock);

  @override
  List<Object> get props => [livestock];
}

final class UpdateLivestockFailure extends UpdateLivestockState {}
