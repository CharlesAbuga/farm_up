import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:livestock_repository/livestock_repository.dart';

part 'create_livestock_event.dart';
part 'create_livestock_state.dart';

class CreateLivestockBloc
    extends Bloc<CreateLivestockEvent, CreateLivestockState> {
  final LivestockRepository _livestockRepository;
  CreateLivestockBloc({required LivestockRepository livestockRepository})
      : _livestockRepository = livestockRepository,
        super(CreateLivestockInitial()) {
    on<CreateLivestock>((event, emit) async {
      emit(CreateLivestockLoading());
      try {
        await _livestockRepository.addLivestock(event.livestock);
        emit(CreateLivestockSuccess(event.livestock));
      } catch (e) {
        emit(CreateLivestockFailure());
      }
    });
  }
}
