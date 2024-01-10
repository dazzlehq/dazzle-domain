import 'dart:convert';

import 'package:dazzle_domain/src/domain/entities/journalist_classification.dart';

class ArticleClassification {
  final CompanyType companyType;
  final GeoRegion geoRegion;
  final ArticleType articleType;
  final bool isEmpty;
  final String? adjustedQuery;

  const ArticleClassification({
    required this.companyType,
    required this.geoRegion,
    required this.articleType,
    required this.adjustedQuery,
  }) : isEmpty = false;

  const ArticleClassification.empty()
      : companyType = CompanyType.undetermined,
        geoRegion = GeoRegion.undetermined,
        articleType = ArticleType.undetermined,
        isEmpty = true,
        adjustedQuery = null;

  factory ArticleClassification.fromJson(Map<String, dynamic> raw) =>
      ArticleClassification(
        companyType: CompanyType.from(raw['company_type']),
        geoRegion: GeoRegion.from(raw['geographical_region']),
        articleType: ArticleType.from(raw['article_type']),
        adjustedQuery: raw['adjusted_query'],
      );

  factory ArticleClassification.fromBase64(String data) =>
      ArticleClassification.fromJson(const JsonDecoder()
          .convert(String.fromCharCodes(const Base64Decoder().convert(data))));

  Map<String, dynamic> toJson() => {
        'company_type': companyType.objectName,
        'geographical_region': geoRegion.objectName,
        'article_type': articleType.objectName,
      };

  String toIngestionValue() => const Base64Codec()
      .encode(const JsonEncoder().convert(toJson()).codeUnits);
}
