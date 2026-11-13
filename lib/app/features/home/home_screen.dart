import 'package:material_ui/material_ui.dart';

import '../../../data/data.dart';
import '../../extensions/extensions.dart';
import '../../widgets/widgets.dart';

// Главный экран со списком сериалов.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Show> _shows = mockShows;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppbar(title: Text('Сериал-гид')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Популярные сериалы',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            6.ph,
            Text(
              'Подборка из ${_shows.length} сериалов',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            20.ph,
            ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: _shows.length,
              itemBuilder: (_, index) => ShowCard(show: _shows[index]),
              separatorBuilder: (_, _) => 14.ph,
            ),
          ],
        ),
      ),
    );
  }
}
