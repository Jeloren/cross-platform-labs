import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/data.dart';
import '../../../di/di.dart';
import 'bloc/show_bloc.dart';
import '../../extensions/extensions.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';

// Экран с описанием сериала.
class ShowScreen extends StatefulWidget {
  const ShowScreen({super.key, required this.showId});
  final int showId;

  @override
  State<ShowScreen> createState() => _ShowScreenState();
}

class _ShowScreenState extends State<ShowScreen> {
  late ShowBloc _show;

  void _loadShow() {
    _show = getIt<ShowBloc>(param1: widget.showId)..add(const ShowLoad());
  }

  @override
  void initState() {
    super.initState();
    _loadShow();
  }

  @override
  void didUpdateWidget(covariant ShowScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showId != widget.showId) {
      _show.close();
      _loadShow();
    }
  }

  Future<void> _refresh() {
    final completer = Completer<void>();
    _show.add(ShowLoad(completer: completer));
    return completer.future;
  }

  @override
  void dispose() {
    _show.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowBloc, ShowState>(
      bloc: _show,
      builder: (context, state) {
        return Scaffold(
          appBar: AppAppbar(
            title: Text(state is ShowLoadSuccess ? state.show.title : 'Сериал'),
          ),
          body: switch (state) {
            ShowInitial() || ShowLoadInProgress() => const Center(
              child: CircularProgressIndicator(),
            ),
            ShowLoadSuccess() => _buildContent(state.show),
            ShowLoadFailure() => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      state.notFound
                          ? Icons.search_off_rounded
                          : Icons.wifi_off_rounded,
                      size: 48,
                    ),
                    16.ph,
                    Text(state.message, textAlign: TextAlign.center),
                    if (!state.notFound) ...[
                      16.ph,
                      FilledButton(
                        onPressed: () => _show.add(const ShowLoad()),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          },
        );
      },
    );
  }

  Widget _buildContent(Show show) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ShowPoster(image: show.image, width: 220, height: 330),
              ),
            ),
            20.ph,
            Text(
              show.title,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            10.ph,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (show.year != null) _InfoChip('${show.year}'),
                if (show.seasons != null) _InfoChip('Сезонов: ${show.seasons}'),
                _InfoChip(show.country),
              ],
            ),
            16.ph,
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                6.pw,
                Text(
                  show.rating?.toStringAsFixed(1) ?? '—',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(' / 10', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            20.ph,
            Text('О сериале', style: Theme.of(context).textTheme.titleLarge),
            8.ph,
            Text(
              show.description,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontSize: 16, height: 1.5),
            ),
            20.ph,
            _InfoRow(
              label: 'Жанры',
              value: show.genres.isEmpty
                  ? 'Не указаны'
                  : show.genres.join(', '),
            ),
            _InfoRow(
              label: 'Премьера',
              value: show.year?.toString() ?? 'Не указана',
            ),
            _InfoRow(label: 'Страна', value: show.country),
            _InfoRow(label: 'Телеканал', value: show.network),
            if (show.seasons != null)
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
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: ThemeColors.accent),
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
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
