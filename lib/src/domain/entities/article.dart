import 'package:dazzle_domain/src/domain/entities/article_classification.dart';
import 'package:dazzle_domain/src/domain/entities/journalist.dart';

class Article {
  final String id;
  final String title;
  final String body;
  final Uri url;
  final String date;
  final ArticleClassification? classification;

  bool get hasClassification => classification != null;

  const Article({
    required this.id,
    required this.title,
    required this.body,
    required this.url,
    required this.date,
    required this.classification,
  });

  factory Article.fromJson(Map<String, dynamic> raw) {
    final classification = raw['classification'] as Map?;

    return Article(
      id: raw['id'],
      title: raw['title'],
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
        'body': body,
        'url': url.toString(),
        'date': date,
        'classification': classification,
      };
}

class ClassifiedArticle extends Article {
  ArticleClassification get requireClassification => classification!;

  ClassifiedArticle({
    required super.id,
    required super.title,
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
      body: article.body,
      url: article.url,
      date: article.date,
      classification: article.classification,
    );
  }

  Map<String, dynamic> toIngestionJson(Journalist journalist) => {
        'id': id,
        'title': title,
        'body': body,
        'url': url.toString(),
        'date': date,
        'journalist_id': journalist.id,
        'classification': requireClassification.toIngestionValue(),
      };
}
