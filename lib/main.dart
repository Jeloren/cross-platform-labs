import 'package:material_ui/material_ui.dart';

import 'di/di.dart';
import 'series_guide_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    talker.handle(details.exception, details.stack);
  };

  runApp(const SeriesGuideApp());
}
