import '../models/show.dart';

abstract interface class ShowsRepositoryInterface {
  Future<List<Show>> getShows();
  Future<Show> getShow(int id);
}
