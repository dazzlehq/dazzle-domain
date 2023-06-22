import 'dart:convert';

import 'package:dazzle_domain/src/domain/entities/journalist_classification.dart';

class ArticleClassification {
  final CompanyType companyType;
  final GeoRegion geoRegion;
  final ArticleType articleType;
  final LatLong? location;
  final bool isEnglish;
  final bool isEmpty;
  final String? adjustedQuery;

  const ArticleClassification({
    required this.companyType,
    required this.geoRegion,
    required this.articleType,
    required this.location,
    required this.isEnglish,
    required this.adjustedQuery,
  }) : isEmpty = false;

  const ArticleClassification.empty()
      : companyType = CompanyType.undetermined,
        geoRegion = GeoRegion.undetermined,
        articleType = ArticleType.undetermined,
        location = null,
        isEnglish = true,
        isEmpty = true,
        adjustedQuery = null;

  factory ArticleClassification.fromJson(Map<String, dynamic> raw) =>
      ArticleClassification(
        companyType: CompanyType.from(raw['company_type']),
        geoRegion: GeoRegion.from(raw['geographical_region']),
        articleType: ArticleType.from(raw['article_type']),
        location:
            raw['location'] != null ? LatLong.fromJson(raw['location']) : null,
        isEnglish: raw['is_english'] ?? true,
        adjustedQuery: raw['adjusted_query'],
      );

  factory ArticleClassification.fromBase64(String data) =>
      ArticleClassification.fromJson(const JsonDecoder()
          .convert(String.fromCharCodes(const Base64Decoder().convert(data))));

  Map<String, dynamic> toJson() => {
        'company_type': companyType.objectName,
        'geographical_region': geoRegion.objectName,
        'article_type': articleType.objectName,
        'location': location,
      };

  String toIngestionValue() => const Base64Codec()
      .encode(const JsonEncoder().convert(toJson()).codeUnits);
}

class LatLong {
  final double lat, long;

  const LatLong({
    required this.lat,
    required this.long,
  });

  factory LatLong.fromJson(Map<String, dynamic> raw) => LatLong(
        lat: raw['lat'],
        long: raw['long'],
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'long': long,
      };
}
