part of 'update_livestock_bloc.dart';

abstract class UpdateLivestockEvent extends Equatable {
  const UpdateLivestockEvent();

  @override
  List<Object> get props => [];
}

class UpdateLivestock extends UpdateLivestockEvent {
  final Livestock livestock;

  const UpdateLivestock(this.livestock);

  @override
  List<Object> get props => [livestock];
}
