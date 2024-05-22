import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:livestock_repository/livestock_repository.dart';

part 'update_livestock_event.dart';
part 'update_livestock_state.dart';

class UpdateLivestockBloc
    extends Bloc<UpdateLivestockEvent, UpdateLivestockState> {
  final LivestockRepository _livestockRepository;

  UpdateLivestockBloc({required LivestockRepository livestockRepository})
      : _livestockRepository = livestockRepository,
        super(UpdateLivestockInitial()) {
    on<UpdateLivestock>((event, emit) async {
      emit(UpdateLivestockLoading());
      try {
        await _livestockRepository.updateLivestock(event.livestock);
        emit(UpdateLivestockSuccess(event.livestock));
      } catch (e) {
        emit(UpdateLivestockFailure());
      }
    });
  }
}
