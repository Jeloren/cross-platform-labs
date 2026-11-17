import 'package:html/parser.dart' as html;
import 'package:json_annotation/json_annotation.dart';

import 'show.dart';

part 'api_show.g.dart';

// Ответ TVmaze с данными сериала.
@JsonSerializable(explicitToJson: true)
class ApiShow {
  const ApiShow({
    required this.id,
    required this.name,
    required this.url,
    this.summary,
    this.genres = const [],
    this.premiered,
    this.image,
    this.rating,
    this.network,
    this.webChannel,
    this.embedded,
  });

  final int id;
  final String name;
  final String url;
  final String? summary;
  final List<String> genres;
  final String? premiered;
  final ApiImage? image;
  final ApiRating? rating;
  final ApiChannel? network;
  final ApiChannel? webChannel;
  @JsonKey(name: '_embedded')
  final ApiEmbedded? embedded;

  factory ApiShow.fromJson(Map<String, dynamic> json) =>
      _$ApiShowFromJson(json);
  Map<String, dynamic> toJson() => _$ApiShowToJson(this);

  Show toShow() {
    final description = html.parse(summary ?? '').body?.text.trim() ?? '';
    final channel = network ?? webChannel;
    return Show(
      id: id,
      title: name,
      description: description.isEmpty
          ? 'Описание пока не добавлено.'
          : description,
      image: image?.medium ?? image?.original ?? '',
      genres: genres,
      rating: rating?.average,
      year: DateTime.tryParse(premiered ?? '')?.year,
      seasons: embedded?.seasons.length,
      country: channel?.country?.name ?? 'Не указана',
      network: channel?.name ?? 'Не указан',
    );
  }
}

// Ссылки на постер.
@JsonSerializable()
class ApiImage {
  const ApiImage({this.medium, this.original});
  final String? medium;
  final String? original;
  factory ApiImage.fromJson(Map<String, dynamic> json) =>
      _$ApiImageFromJson(json);
  Map<String, dynamic> toJson() => _$ApiImageToJson(this);
}

// Средняя оценка на TVmaze.
@JsonSerializable()
class ApiRating {
  const ApiRating({this.average});
  final double? average;
  factory ApiRating.fromJson(Map<String, dynamic> json) =>
      _$ApiRatingFromJson(json);
  Map<String, dynamic> toJson() => _$ApiRatingToJson(this);
}

// Телеканал или интернет-площадка.
@JsonSerializable(explicitToJson: true)
class ApiChannel {
  const ApiChannel({required this.name, this.country});
  final String name;
  final ApiCountry? country;
  factory ApiChannel.fromJson(Map<String, dynamic> json) =>
      _$ApiChannelFromJson(json);
  Map<String, dynamic> toJson() => _$ApiChannelToJson(this);
}

// Страна телеканала.
@JsonSerializable()
class ApiCountry {
  const ApiCountry({required this.name});
  final String name;
  factory ApiCountry.fromJson(Map<String, dynamic> json) =>
      _$ApiCountryFromJson(json);
  Map<String, dynamic> toJson() => _$ApiCountryToJson(this);
}

// Данные, добавленные к ответу сериала.
@JsonSerializable(explicitToJson: true)
class ApiEmbedded {
  const ApiEmbedded({this.seasons = const []});
  final List<ApiSeason> seasons;
  factory ApiEmbedded.fromJson(Map<String, dynamic> json) =>
      _$ApiEmbeddedFromJson(json);
  Map<String, dynamic> toJson() => _$ApiEmbeddedToJson(this);
}

// Сезон сериала.
@JsonSerializable()
class ApiSeason {
  const ApiSeason({required this.id, required this.number});
  final int id;
  final int number;
  factory ApiSeason.fromJson(Map<String, dynamic> json) =>
      _$ApiSeasonFromJson(json);
  Map<String, dynamic> toJson() => _$ApiSeasonToJson(this);
}
