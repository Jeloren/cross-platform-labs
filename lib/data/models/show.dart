// Данные одного сериала.
class Show {
  const Show({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.genres,
    required this.rating,
    required this.year,
    required this.seasons,
    required this.country,
    required this.network,
  });

  final int id;
  final String title;
  final String description;
  final String image;
  final List<String> genres;
  final double rating;
  final int year;
  final int seasons;
  final String country;
  final String network;
}
