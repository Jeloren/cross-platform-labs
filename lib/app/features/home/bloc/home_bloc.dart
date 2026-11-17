import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/show.dart';
import '../../../../data/repositories/shows_repository_interface.dart';
import '../../../../di/di.dart';

part 'home_event.dart';
part 'home_state.dart';

// Состояние списка сериалов.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this.repository) : super(HomeInitial()) {
    on<HomeLoad>(_load);
  }

  final ShowsRepositoryInterface repository;

  Future<void> _load(HomeLoad event, Emitter<HomeState> emit) async {
    try {
      if (state is HomeLoadInProgress) return;
      emit(HomeLoadInProgress());
      final shows = await repository.getShows();
      emit(HomeLoadSuccess(shows: shows));
    } catch (error, stackTrace) {
      talker.handle(error, stackTrace);
      emit(
        const HomeLoadFailure(
          message: 'Не удалось загрузить сериалы. Проверьте интернет и попробуйте ещё раз.',
        ),
      );
    } finally {
      event.completer?.complete();
    }
  }
}
