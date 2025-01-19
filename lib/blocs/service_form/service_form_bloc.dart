import 'package:bank_sha_rafi/models/service_form_model.dart';
import 'package:bank_sha_rafi/services/transaction_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'service_form_event.dart';
part 'service_form_state.dart';

class ServiceBloc extends Bloc<ServiceFormEvent, ServiceState> {
  ServiceBloc() : super(ServiceInitial()) {
    on<ServiceFormEvent>((event, emit) async {
      if (event is ServiceGet) {
        try {
          emit(ServiceLoading());
          print(event);
          final services = await TransactionService().getServices();
          emit(ServiceLoaded(services));
        } catch (e) {
          emit(ServiceError(e.toString()));
        }
      }
    });
    on<ServiceFormPost>((event, emit) async {
      try {
        emit(ServiceLoading());
        print(event);
        final services = await TransactionService().service(event.data);
        emit(ServiceSuccess());
      } catch (e) {
        emit(ServiceError(e.toString()));
      }
    });
  }
}
