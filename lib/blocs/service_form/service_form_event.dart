part of 'service_form_bloc.dart';

abstract class ServiceFormEvent extends Equatable {
  const ServiceFormEvent();

  @override
  List<Object> get props => [];
}
class ServiceFormPost extends ServiceFormEvent {
  final ServiceModel data;
  const ServiceFormPost(this.data);

  @override
  List<Object> get props => [data];
}
class ServiceGet extends ServiceFormEvent {}
