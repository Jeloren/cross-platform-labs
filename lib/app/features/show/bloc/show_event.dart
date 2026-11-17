part of 'show_bloc.dart';

sealed class ShowEvent extends Equatable {
  const ShowEvent();
  @override
  List<Object?> get props => [];
}

class ShowLoad extends ShowEvent {
  const ShowLoad({this.completer});
  final Completer<void>? completer;
  @override
  List<Object?> get props => [completer];
}
