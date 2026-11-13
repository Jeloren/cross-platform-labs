import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:series_guide/app/features/home/home_screen.dart';
import 'package:series_guide/app/features/show/show_screen.dart';

void main() {
  testWidgets('Карточки помещаются на узком экране с крупным текстом', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: const HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -1500),
    );
    await tester.pumpAndSettle();
    expect(find.text('Северный ветер'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Для отсутствующего сериала есть понятное сообщение', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ShowScreen(showId: 999)));
    await tester.pumpAndSettle();
    expect(find.text('Сериал не найден'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Длинное описание прокручивается до последних полей', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: ShowScreen(showId: 102)));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -1500),
    );
    await tester.pumpAndSettle();
    expect(find.text('Netflix'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
