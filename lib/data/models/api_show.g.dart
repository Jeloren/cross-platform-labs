// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_show.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiShow _$ApiShowFromJson(Map<String, dynamic> json) => ApiShow(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  url: json['url'] as String,
  summary: json['summary'] as String?,
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  premiered: json['premiered'] as String?,
  image: json['image'] == null
      ? null
      : ApiImage.fromJson(json['image'] as Map<String, dynamic>),
  rating: json['rating'] == null
      ? null
      : ApiRating.fromJson(json['rating'] as Map<String, dynamic>),
  network: json['network'] == null
      ? null
      : ApiChannel.fromJson(json['network'] as Map<String, dynamic>),
  webChannel: json['webChannel'] == null
      ? null
      : ApiChannel.fromJson(json['webChannel'] as Map<String, dynamic>),
  embedded: json['_embedded'] == null
      ? null
      : ApiEmbedded.fromJson(json['_embedded'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApiShowToJson(ApiShow instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'url': instance.url,
  'summary': instance.summary,
  'genres': instance.genres,
  'premiered': instance.premiered,
  'image': instance.image?.toJson(),
  'rating': instance.rating?.toJson(),
  'network': instance.network?.toJson(),
  'webChannel': instance.webChannel?.toJson(),
  '_embedded': instance.embedded?.toJson(),
};

ApiImage _$ApiImageFromJson(Map<String, dynamic> json) => ApiImage(
  medium: json['medium'] as String?,
  original: json['original'] as String?,
);

Map<String, dynamic> _$ApiImageToJson(ApiImage instance) => <String, dynamic>{
  'medium': instance.medium,
  'original': instance.original,
};

ApiRating _$ApiRatingFromJson(Map<String, dynamic> json) =>
    ApiRating(average: (json['average'] as num?)?.toDouble());

Map<String, dynamic> _$ApiRatingToJson(ApiRating instance) => <String, dynamic>{
  'average': instance.average,
};

ApiChannel _$ApiChannelFromJson(Map<String, dynamic> json) => ApiChannel(
  name: json['name'] as String,
  country: json['country'] == null
      ? null
      : ApiCountry.fromJson(json['country'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApiChannelToJson(ApiChannel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'country': instance.country?.toJson(),
    };

ApiCountry _$ApiCountryFromJson(Map<String, dynamic> json) =>
    ApiCountry(name: json['name'] as String);

Map<String, dynamic> _$ApiCountryToJson(ApiCountry instance) =>
    <String, dynamic>{'name': instance.name};

ApiEmbedded _$ApiEmbeddedFromJson(Map<String, dynamic> json) => ApiEmbedded(
  seasons:
      (json['seasons'] as List<dynamic>?)
          ?.map((e) => ApiSeason.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ApiEmbeddedToJson(ApiEmbedded instance) =>
    <String, dynamic>{
      'seasons': instance.seasons.map((e) => e.toJson()).toList(),
    };

ApiSeason _$ApiSeasonFromJson(Map<String, dynamic> json) => ApiSeason(
  id: (json['id'] as num).toInt(),
  number: (json['number'] as num).toInt(),
);

Map<String, dynamic> _$ApiSeasonToJson(ApiSeason instance) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
};
