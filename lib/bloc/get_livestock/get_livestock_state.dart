part of 'get_livestock_bloc.dart';

sealed class GetLivestockState extends Equatable {
  const GetLivestockState();

  @override
  List<Object> get props => [];
}

final class GetLivestockInitial extends GetLivestockState {}

final class GetLivestockLoading extends GetLivestockState {}

final class GetLivestockSuccess extends GetLivestockState {
  final List<Livestock> livestock;

  const GetLivestockSuccess(this.livestock);

  @override
  List<Object> get props => [livestock];
}

final class GetLivestockFailure extends GetLivestockState {}
