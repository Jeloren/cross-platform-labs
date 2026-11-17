import 'package:dio/dio.dart';
import 'package:series_guide/app/features/show/bloc/show_bloc.dart';
import 'package:series_guide/app/features/home/bloc/home_bloc.dart';
import 'package:series_guide/data/models/show.dart';
import 'package:series_guide/data/repositories/shows_repository_interface.dart';
import 'package:series_guide/di/di.dart';

import 'mock_shows.dart';

class TestRepository implements ShowsRepositoryInterface {
  TestRepository({
    this.failures = 0,
    this.shows = mockShows,
    this.detailFailures = 0,
    this.loadShow,
  });
  int failures;
  int calls = 0;
  int detailFailures;
  int detailCalls = 0;
  final List<int> requestedIds = [];
  final Future<Show> Function(int)? loadShow;
  final List<Show> shows;

  @override
  Future<List<Show>> getShows() async {
    calls++;
    if (failures > 0) {
      failures--;
      throw StateError('Нет соединения');
    }
    return shows;
  }

  @override
  Future<Show> getShow(int id) async {
    detailCalls++;
    requestedIds.add(id);
    if (detailFailures > 0) {
      detailFailures--;
      throw DioException(
        requestOptions: RequestOptions(path: '/shows/$id'),
        type: DioExceptionType.connectionError,
      );
    }
    if (loadShow != null) return loadShow!(id);
    for (final show in shows) {
      if (show.id == id) return show;
    }
    final options = RequestOptions(path: '/shows/$id');
    throw DioException(
      requestOptions: options,
      response: Response(requestOptions: options, statusCode: 404),
      type: DioExceptionType.badResponse,
    );
  }
}

Future<void> registerTestRepository(ShowsRepositoryInterface repository) async {
  await getIt.reset();
  getIt.registerFactory<HomeBloc>(() => HomeBloc(repository));
  getIt.registerFactoryParam<ShowBloc, int, void>(
    (id, _) => ShowBloc(repository, showId: id),
  );
}
