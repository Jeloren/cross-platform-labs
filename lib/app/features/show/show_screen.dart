import 'package:material_ui/material_ui.dart';

import '../../../data/data.dart';
import '../../extensions/extensions.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';

// Экран с описанием сериала.
class ShowScreen extends StatelessWidget {
  const ShowScreen({super.key, required this.showId});

  final int showId;

  Show? _findShow() {
    for (final show in mockShows) {
      if (show.id == showId) {
        return show;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final show = _findShow();

    if (show == null) {
      return Scaffold(
        appBar: const AppAppbar(title: Text('Сериал')),
        body: const Center(child: Text('Сериал не найден')),
      );
    }

    return Scaffold(
      appBar: AppAppbar(title: Text(show.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  show.image,
                  width: 220,
                  height: 330,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            20.ph,
            Text(
              show.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            10.ph,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip('${show.year}'),
                _InfoChip('Сезонов: ${show.seasons}'),
                _InfoChip(show.country),
              ],
            ),
            16.ph,
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 28,
                ),
                6.pw,
                Text(
                  show.rating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  ' / 10',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            20.ph,
            Text(
              'О сериале',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            8.ph,
            Text(
              show.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    height: 1.5,
                  ),
            ),
            20.ph,
            _InfoRow(label: 'Жанры', value: show.genres.join(', ')),
            _InfoRow(label: 'Премьера', value: '${show.year}'),
            _InfoRow(label: 'Страна', value: show.country),
            _InfoRow(label: 'Телеканал', value: show.network),
            _InfoRow(label: 'Сезонов', value: '${show.seasons}'),
          ],
        ),
      ),
    );
  }
}

// Короткая подпись под названием.
class _InfoChip extends StatelessWidget {
  const _InfoChip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ThemeColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ThemeColors.accent,
            ),
      ),
    );
  }
}

// Строка с характеристикой сериала.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
