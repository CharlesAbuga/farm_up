part of 'create_livestock_bloc.dart';

abstract class CreateLivestockEvent extends Equatable {
  const CreateLivestockEvent();

  @override
  List<Object> get props => [];
}

class CreateLivestock extends CreateLivestockEvent {
  final Livestock livestock;

  const CreateLivestock(this.livestock);

  @override
  List<Object> get props => [livestock];
}
