import 'package:bank_sha_rafi/models/tips_model.dart';
import 'package:bank_sha_rafi/services/tips_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tips_event.dart';
part 'tips_state.dart';

class TipsBloc extends Bloc<TipsEvent, TipsState> {
  TipsBloc() : super(TipsInitial()) {
    on<TipsEvent>((event, emit) async {
      if (event is TipsGet) {
        try {
          emit(TipsLoading());

          final tips = await TipsService().getTips();
          print(tips);
          emit(TipsSuccess(tips));
        } catch (e) {
          emit(TipsFailed(e.toString()));
        }
      }
    });
  }
}
