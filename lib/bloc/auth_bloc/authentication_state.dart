part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationInitialState extends AuthenticationState {}

class AuthGetFailureState extends AuthenticationState {
  final String error;
  AuthGetFailureState({required this.error});
}

class AuthGetSuccess extends AuthenticationState {
  final Pegawai user;
  AuthGetSuccess({required this.user});
}

class AuthLoggedInState extends AuthenticationState {
  final String name;
  AuthLoggedInState(this.name);

}

class AuthLoggedOutState extends AuthenticationState {}

class AuthLoadingState extends AuthenticationState {}
