import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../app/features/home/bloc/home_bloc.dart';
import '../app/features/show/bloc/show_bloc.dart';
import '../data/dio/set_up.dart';
import '../data/repositories/shows_repository.dart';
import '../data/repositories/shows_repository_interface.dart';

final getIt = GetIt.instance;
final talker = TalkerFlutter.init();

Future<void> setupLocator() async {
  final dio = Dio();
  setUpDio(dio, talker);
  getIt.registerSingleton<Talker>(talker);
  getIt.registerSingleton<Dio>(dio);
  getIt.registerSingleton<ShowsRepositoryInterface>(ShowsRepository(dio: dio));
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(getIt<ShowsRepositoryInterface>()),
  );
  getIt.registerFactoryParam<ShowBloc, int, void>(
    (id, _) => ShowBloc(getIt<ShowsRepositoryInterface>(), showId: id),
  );
}
