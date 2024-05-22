part of 'get_livestock_bloc.dart';

abstract class GetLivestockEvent extends Equatable {
  const GetLivestockEvent();

  @override
  List<Object> get props => [];
}

class GetLivestock extends GetLivestockEvent {
  final String userId;
  const GetLivestock(this.userId);

  @override
  List<Object> get props => [];
}
