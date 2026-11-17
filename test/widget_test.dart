import 'package:flutter_test/flutter_test.dart';

import 'package:series_guide/series_guide_app.dart';
import 'package:series_guide/app/router/router.dart';

import 'fixtures/test_repository.dart';

void main() {
  setUp(() async {
    await registerTestRepository(TestRepository());
    router.go('/home');
  });
  testWidgets('На главном экране отображается список сериалов', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SeriesGuideApp());
    await tester.pumpAndSettle();

    expect(find.text('Сериал-гид'), findsOneWidget);
    expect(find.text('Каталог сериалов'), findsOneWidget);
    expect(find.text('Тёмный город'), findsOneWidget);
    expect(find.text('Орбита'), findsOneWidget);
  });

  testWidgets('По нажатию на карточку открывается экран сериала', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SeriesGuideApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Тёмный город'));
    await tester.pumpAndSettle();

    expect(find.text('О сериале'), findsOneWidget);
    expect(find.text('Первый канал'), findsOneWidget);
  });
}
