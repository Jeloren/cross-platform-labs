import 'package:dio/dio.dart';

import '../endpoints.dart';
import '../models/api_show.dart';
import '../models/show.dart';
import 'shows_repository_interface.dart';

// Загрузка каталога сериалов.
class ShowsRepository implements ShowsRepositoryInterface {
  ShowsRepository({required this.dio});
  final Dio dio;

  @override
  Future<List<Show>> getShows() async {
    final response = await dio.get<List<dynamic>>(
      Endpoints.shows,
      queryParameters: {'page': 0},
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Сервер вернул пустой ответ');
    }
    return data.take(20).map((item) {
      return ApiShow.fromJson(item as Map<String, dynamic>).toShow();
    }).toList();
  }

  @override
  Future<Show> getShow(int id) async {
    if (id <= 0) throw ArgumentError.value(id, 'id');
    final response = await dio.get<Map<String, dynamic>>(
      Endpoints.show(id),
      queryParameters: {'embed': 'seasons'},
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Сервер вернул пустой ответ');
    }
    return ApiShow.fromJson(data).toShow();
  }
}
