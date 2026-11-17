import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../di/di.dart';
import '../../extensions/extensions.dart';
import '../../widgets/widgets.dart';
import 'bloc/home_bloc.dart';

// Главный экран со списком сериалов.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeBloc _home;

  @override
  void initState() {
    super.initState();
    _home = getIt<HomeBloc>()..add(const HomeLoad());
  }

  Future<void> _refresh() {
    final completer = Completer<void>();
    _home.add(HomeLoad(completer: completer));
    return completer.future;
  }

  @override
  void dispose() {
    _home.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppbar(title: Text('Сериал-гид')),
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: _home,
        builder: (context, state) {
          return switch (state) {
            HomeInitial() || HomeLoadInProgress() => const Center(
              child: CircularProgressIndicator(),
            ),
            HomeLoadFailure() => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 48),
                    16.ph,
                    Text(state.message, textAlign: TextAlign.center),
                    16.ph,
                    FilledButton(
                      onPressed: () => _home.add(const HomeLoad()),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            ),
            HomeLoadSuccess() => _buildShows(state),
          };
        },
      ),
    );
  }

  Widget _buildShows(HomeLoadSuccess state) {
    final shows = state.shows;
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: shows.length + 2,
        separatorBuilder: (_, _) => 14.ph,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Каталог сериалов',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                6.ph,
                Text(
                  shows.isEmpty
                      ? 'Список пока пуст'
                      : 'Загружено: ${shows.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          }
          if (index == shows.length + 1) {
            return Text(
              'Данные: TVmaze (tvmaze.com)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            );
          }
          return ShowCard(show: shows[index - 1]);
        },
      ),
    );
  }
}
