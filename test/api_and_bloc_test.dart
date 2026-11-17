import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:series_guide/app/features/home/bloc/home_bloc.dart';
import 'package:series_guide/app/features/home/home_screen.dart';
import 'package:series_guide/data/models/api_show.dart';
import 'package:series_guide/data/repositories/shows_repository.dart';

import 'fixtures/test_repository.dart';

void main() {
  test('JSON: вложенные поля, HTML и обратная сериализация', () {
    final json = <String, dynamic>{
      'id': 1,
      'name': 'Under the Dome',
      'url': 'https://www.tvmaze.com/shows/1/under-the-dome',
      'summary': '<p>A <b>town</b> &amp; its people.</p>',
      'genres': ['Drama', 'Science-Fiction'],
      'premiered': '2013-06-24',
      'image': {'medium': 'https://example.com/poster.jpg', 'original': null},
      'rating': {'average': 7},
      'network': {
        'name': 'CBS',
        'country': {'name': 'United States'},
      },
    };
    final api = ApiShow.fromJson(json);
    final show = api.toShow();
    expect(show.title, 'Under the Dome');
    expect(show.description, 'A town & its people.');
    expect(show.rating, 7.0);
    expect(show.year, 2013);
    expect(show.network, 'CBS');
    expect(show.country, 'United States');
    expect(show.seasons, isNull);
    expect(ApiShow.fromJson(api.toJson()).image?.medium, show.image);
  });

  test('JSON: отсутствие постера, рейтинга и даты не ломает модель', () {
    final show = ApiShow.fromJson({
      'id': 2,
      'name': 'Без описания',
      'url': 'https://www.tvmaze.com/shows/2',
      'summary': null,
      'image': null,
      'rating': {'average': null},
      'genres': [],
      'premiered': null,
      'network': null,
      'webChannel': {'name': 'Netflix', 'country': null},
    }).toShow();
    expect(show.description, 'Описание пока не добавлено.');
    expect(show.image, isEmpty);
    expect(show.rating, isNull);
    expect(show.year, isNull);
    expect(show.network, 'Netflix');
    expect(show.country, 'Не указана');
  });

  test('Репозиторий запрашивает первую страницу и берёт 20 записей', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.tvmaze.com'));
    addTearDown(dio.close);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, '/shows');
          expect(options.queryParameters, {'page': 0});
          handler.resolve(
            Response(
              requestOptions: options,
              data: List.generate(
                25,
                (i) => {
                  'id': i + 1,
                  'name': 'Сериал $i',
                  'url': 'https://www.tvmaze.com/shows/${i + 1}',
                },
              ),
            ),
          );
        },
      ),
    );
    final result = await ShowsRepository(dio: dio).getShows();
    expect(result, hasLength(20));
    expect(result.first.id, 1);
    expect(result.last.id, 20);
  });

  test('BLoC: загрузка, ошибка и успешный повтор', () async {
    final repository = TestRepository(failures: 1);
    final bloc = HomeBloc(repository);
    addTearDown(bloc.close);
    final expected = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<HomeLoadInProgress>(),
        isA<HomeLoadFailure>(),
        isA<HomeLoadInProgress>(),
        isA<HomeLoadSuccess>(),
      ]),
    );
    final first = Completer<void>();
    bloc.add(HomeLoad(completer: first));
    await first.future;
    final second = Completer<void>();
    bloc.add(HomeLoad(completer: second));
    await second.future;
    await expected;
    expect(repository.calls, 2);
  });

  testWidgets('Ошибка загрузки и кнопка Повторить', (tester) async {
    final repository = TestRepository(failures: 1);
    await registerTestRepository(repository);
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();
    expect(find.textContaining('Не удалось загрузить сериалы'), findsOneWidget);
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    expect(find.text('Тёмный город'), findsOneWidget);
    expect(repository.calls, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Пустой ответ показывает пустой список', (tester) async {
    await registerTestRepository(TestRepository(shows: []));
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Список пока пуст'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
