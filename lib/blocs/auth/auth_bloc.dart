import 'package:bank_sha_rafi/models/sign_in_form_model.dart';
import 'package:bank_sha_rafi/models/sign_up_form_model.dart';
import 'package:bank_sha_rafi/models/user_edit_form_model.dart';
import 'package:bank_sha_rafi/models/user_model.dart';
import 'package:bank_sha_rafi/services/auth_service.dart';
import 'package:bank_sha_rafi/services/wallet_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.dart';
part 'auth_state.dart';
// part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // final AuthService authService;
  // AuthBloc(
  //   this.authService,
  // ) : super(const _Initial()) {
  //   on<_SignUp>((event, emit) async {
  //     emit(const _Loading());
  //     final response = await authService.signUp(
  //       event.email,
  //       event.password,
  //       event.name,
  //       event.nim,
  //     );

  //     response.fold(
  //       (l) => emit(_Error(l)),
  //       (r) => emit(_SuccessSignUp(r)),
  //     );
  //   });
  // }
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthCheckEmail) {
        try {
          emit(AuthLoading());

          final res = await AuthService().checkEmail(event.email);
          if (res == false) {
            emit(AuthCheckEmailSuccess());
          } else {
            emit(const AuthFailed('email sudah dipakai'));
          }
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthRegister) {
        try {
          emit(AuthLoading());
          print(event.data);
          final res = await AuthService().register(event.data);

          emit(AuthSuccess(res));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthLogin) {
        try {
          emit(AuthLoading());
                  print(event.data);

          final res = await AuthService().login(event.data);

          emit(AuthSuccess(res));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthGetCurrent) {
        try {
          emit(AuthLoading());

          final SignInFormModel res =
              await AuthService().getCredentialFromLocal();

          final UserModel user = await AuthService().login(res);

          emit(AuthSuccess(user));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthUpdateUser) {
        try {
          emit(AuthLoading());

          await AuthService().updateUser(event.data);

          final updatedUser = event.user.copyWith(
            name: event.data.name,
            username: event.data.username,
            email: event.data.email,
          );

          emit(AuthSuccess(updatedUser));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthUpdatePin) {
        try {
          emit(AuthLoading());

          await WalletService().updatePin(event.oldPin, event.newPin);

          final updatedUser = event.user.copyWith(
            pin: event.newPin,
          );

          emit(AuthSuccess(updatedUser));
        } catch (e) {}
      }

      if (event is AuthUpdateBalance) {
        if (state is AuthSuccess) {
          final currentUser = (state as AuthSuccess).data;
          final updatedUser = currentUser.copyWith(
            balance: currentUser.balance! + event.amount,
          );

          emit(AuthSuccess(updatedUser));
        }
      }
    });
  }
}
