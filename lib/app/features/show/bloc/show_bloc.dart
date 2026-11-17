import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/show.dart';
import '../../../../data/repositories/shows_repository_interface.dart';
import '../../../../di/di.dart';

part 'show_event.dart';
part 'show_state.dart';

// Загрузка одного сериала.
class ShowBloc extends Bloc<ShowEvent, ShowState> {
  ShowBloc(this.repository, {required this.showId}) : super(ShowInitial()) {
    on<ShowLoad>(_load);
  }

  final ShowsRepositoryInterface repository;
  final int showId;

  Future<void> _load(ShowLoad event, Emitter<ShowState> emit) async {
    try {
      if (state is ShowLoadInProgress) return;
      emit(ShowLoadInProgress());
      if (showId <= 0) {
        emit(
          const ShowLoadFailure(message: 'Сериал не найден', notFound: true),
        );
        return;
      }
      final show = await repository.getShow(showId);
      emit(ShowLoadSuccess(show: show));
    } on DioException catch (error, stackTrace) {
      talker.handle(error, stackTrace);
      if (error.response?.statusCode == 404) {
        emit(
          const ShowLoadFailure(message: 'Сериал не найден', notFound: true),
        );
      } else {
        emit(
          const ShowLoadFailure(
            message: 'Не удалось загрузить данные сериала. Проверьте интернет и попробуйте ещё раз.',
          ),
        );
      }
    } catch (error, stackTrace) {
      talker.handle(error, stackTrace);
      emit(
        const ShowLoadFailure(
          message: 'Не удалось загрузить данные сериала. Попробуйте ещё раз.',
        ),
      );
    } finally {
      event.completer?.complete();
    }
  }
}
