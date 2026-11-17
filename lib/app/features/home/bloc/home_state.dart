part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoadInProgress extends HomeState {}

final class HomeLoadSuccess extends HomeState {
  const HomeLoadSuccess({required this.shows});
  final List<Show> shows;
  @override
  List<Object?> get props => [shows];
}

final class HomeLoadFailure extends HomeState {
  const HomeLoadFailure({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
