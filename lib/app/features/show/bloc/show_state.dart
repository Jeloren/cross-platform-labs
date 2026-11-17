part of 'show_bloc.dart';

sealed class ShowState extends Equatable {
  const ShowState();
  @override
  List<Object?> get props => [];
}

final class ShowInitial extends ShowState {}

final class ShowLoadInProgress extends ShowState {}

final class ShowLoadSuccess extends ShowState {
  const ShowLoadSuccess({required this.show});
  final Show show;
  @override
  List<Object?> get props => [show];
}

final class ShowLoadFailure extends ShowState {
  const ShowLoadFailure({required this.message, this.notFound = false});
  final String message;
  final bool notFound;
  @override
  List<Object?> get props => [message, notFound];
}
