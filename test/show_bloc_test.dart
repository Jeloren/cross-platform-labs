import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:series_guide/app/features/show/bloc/show_bloc.dart';
import 'package:series_guide/app/features/show/show_screen.dart';
import 'package:series_guide/app/router/router.dart';
import 'package:series_guide/data/models/api_show.dart';
import 'package:series_guide/data/models/show.dart';
import 'package:series_guide/data/repositories/shows_repository.dart';
import 'package:series_guide/series_guide_app.dart';

import 'fixtures/mock_shows.dart';
import 'fixtures/test_repository.dart';

void main() {
  test('Детали запрашиваются по ID вместе с настоящими сезонами', () async {
    final json = jsonDecode(
      File('test/fixtures/api_show_details.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final dio = Dio(BaseOptions(baseUrl: 'https://api.tvmaze.com'));
    addTearDown(dio.close);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, '/shows/1');
          expect(options.queryParameters, {'embed': 'seasons'});
          handler.resolve(Response(requestOptions: options, data: json));
        },
      ),
    );
    final show = await ShowsRepository(dio: dio).getShow(1);
    expect(show.id, 1);
    expect(show.title, 'Under the Dome');
    expect(show.seasons, 3);
    final api = ApiShow.fromJson(json);
    expect(ApiShow.fromJson(api.toJson()).embedded?.seasons.length, 3);
  });

  test('Отсутствие вложенных сезонов не подменяется нулём', () {
    final show = ApiShow.fromJson({
      'id': 1,
      'name': 'Example',
      'url': 'https://www.tvmaze.com/shows/1',
    }).toShow();
    expect(show.seasons, isNull);
  });

  test(
    'ShowBloc повторяет запрос того же ID после ошибки соединения',
    () async {
      final repository = TestRepository(detailFailures: 1);
      final bloc = ShowBloc(repository, showId: 101);
      addTearDown(bloc.close);
      final result = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ShowLoadInProgress>(),
          isA<ShowLoadFailure>(),
          isA<ShowLoadInProgress>(),
          isA<ShowLoadSuccess>(),
        ]),
      );
      for (var i = 0; i < 2; i++) {
        final completer = Completer<void>();
        bloc.add(ShowLoad(completer: completer));
        await completer.future;
      }
      await result;
      expect(repository.requestedIds, [101, 101]);
      expect(repository.detailCalls, 2);
    },
  );

  test('Неверный ID не отправляется в репозиторий', () async {
    final repository = TestRepository();
    final bloc = ShowBloc(repository, showId: 0);
    addTearDown(bloc.close);
    final result = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ShowLoadInProgress>(),
        isA<ShowLoadFailure>().having((s) => s.notFound, 'notFound', true),
      ]),
    );
    bloc.add(const ShowLoad());
    await result;
    expect(repository.detailCalls, 0);
  });

  testWidgets('Пока сервер не ответил, второй экран показывает загрузку', (
    tester,
  ) async {
    final pending = Completer<Show>();
    await registerTestRepository(
      TestRepository(loadShow: (_) => pending.future),
    );
    await tester.pumpWidget(const MaterialApp(home: ShowScreen(showId: 101)));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('О сериале'), findsNothing);
    pending.complete(mockShows.first);
    await tester.pumpAndSettle();
    expect(find.text('О сериале'), findsOneWidget);
    expect(find.text('Сезонов: 3'), findsOneWidget);
  });

  testWidgets('Кнопка повтора на втором экране загружает данные', (
    tester,
  ) async {
    final repository = TestRepository(detailFailures: 1);
    await registerTestRepository(repository);
    await tester.pumpWidget(const MaterialApp(home: ShowScreen(showId: 101)));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Не удалось загрузить данные сериала'),
      findsOneWidget,
    );
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    expect(find.text('О сериале'), findsOneWidget);
    expect(repository.requestedIds, [101, 101]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Ответ 404 показывает отсутствие сериала без кнопки повтора', (
    tester,
  ) async {
    await registerTestRepository(TestRepository());
    await tester.pumpWidget(const MaterialApp(home: ShowScreen(showId: 999)));
    await tester.pumpAndSettle();
    expect(find.text('Сериал не найден'), findsOneWidget);
    expect(find.text('Повторить'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Прямой маршрут работает без передачи extra', (tester) async {
    final repository = TestRepository();
    await registerTestRepository(repository);
    router.go('/show/102');
    await tester.pumpWidget(const SeriesGuideApp());
    await tester.pumpAndSettle();
    expect(find.text('Орбита'), findsWidgets);
    expect(repository.requestedIds, [102]);
    router.go('/home');
    await tester.pumpAndSettle();
  });

  testWidgets('При смене ID в том же виджете загружается другой сериал', (
    tester,
  ) async {
    final repository = TestRepository();
    await registerTestRepository(repository);
    await tester.pumpWidget(const MaterialApp(home: ShowScreen(showId: 101)));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const MaterialApp(home: ShowScreen(showId: 102)));
    await tester.pumpAndSettle();
    expect(find.text('Орбита'), findsWidgets);
    expect(repository.requestedIds, [101, 102]);
    expect(tester.takeException(), isNull);
  });
}
