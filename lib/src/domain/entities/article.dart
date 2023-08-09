import 'package:dazzle_domain/dazzle_domain.dart';

class Article {
  final String id;
  final String title;
  final String? enhancedTitle;
  final String body;
  final String author;
  final Uri url;
  final String date;
  final ArticleClassification? classification;

  bool get hasClassification => classification != null;

  const Article({
    required this.id,
    required this.title,
    required this.enhancedTitle,
    required this.body,
    required this.author,
    required this.url,
    required this.date,
    required this.classification,
  });

  @override
  bool operator ==(Object other) {
    if (other is Article) {
      return other.hashCode == hashCode;
    }

    return false;
  }

  @override
  int get hashCode => id.hashCode;

  factory Article.fromJson(Map<String, dynamic> raw) {
    final classification = raw['classification'] as Map?;

    return Article(
      id: raw['id'],
      title: raw['title'],
      author: raw['author'],
      enhancedTitle: raw['enhanced_title'],
      body: raw['body'],
      url: Uri.parse(raw['url'] as String),
      date: raw['date'],
      classification:
          classification != null && classification['company_type'] != null
              ? ArticleClassification.fromJson(
                  classification.cast<String, dynamic>())
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'enhanced_title': enhancedTitle,
        'body': body,
        'url': url.toString(),
        'date': date,
        'classification': classification,
      };

  Article withEnhancedTitle(String enhancedTitle) => Article(
        id: id,
        title: title,
        author: author,
        enhancedTitle: enhancedTitle,
        body: body,
        url: url,
        date: date,
        classification: classification,
      );
}

class ClassifiedArticle extends Article {
  ArticleClassification get requireClassification => classification!;

  ClassifiedArticle({
    required super.id,
    required super.title,
    required super.author,
    required super.enhancedTitle,
    required super.body,
    required super.url,
    required super.date,
    required super.classification,
  });

  factory ClassifiedArticle.fromJson(Map<String, dynamic> raw) {
    final article = Article.fromJson(raw);

    return ClassifiedArticle(
      id: article.id,
      title: article.title,
      author: article.author,
      enhancedTitle: article.enhancedTitle,
      body: article.body,
      url: article.url,
      date: article.date,
      classification: article.classification,
    );
  }

  Map<String, dynamic> toIngestionJson(
          String outletId, List<String> journalistIds) =>
      {
        'id': id,
        'group_name': 'ART',
        'title': title,
        'enhanced_title': enhancedTitle,
        'body': body,
        'url': url.toString(),
        'date': date,
        'outlet_id': outletId,
        'journalist_id': journalistIds.toSet().toList(growable: false),
        'classification_company_type': classification?.companyType.objectName,
        'classification_geo_region': classification?.geoRegion.objectName,
        'classification_article_type': classification?.articleType.objectName,
        'classification_lat': classification?.location?.lat ?? .0,
        'classification_long': classification?.location?.long ?? .0,
      };
}
