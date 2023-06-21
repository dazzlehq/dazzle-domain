import 'package:dazzle_domain/src/domain/entities/article.dart';
import 'package:dazzle_domain/src/domain/entities/journalist_classification.dart';

class Journalist {
  final String id;
  final Uri link;
  final Uri articleLink;
  final String name;
  final Uri? image;
  final String? location;
  final List<String> links;
  final DateTime lastBioUpdate;
  final String? tmpBio;
  final JournalistClassification? classification;

  Journalist({
    required this.id,
    required this.name,
    required this.link,
    required this.location,
    required Iterable<String> links,
    required this.image,
    required this.lastBioUpdate,
    required this.classification,
    required this.tmpBio,
  })  : links = links.map((it) => it.toLowerCase()).toList(),
        articleLink =
            link.replace(pathSegments: [...link.pathSegments, 'articles']);

  @override
  bool operator ==(Object other) {
    if (other is Journalist) {
      return other.hashCode == hashCode;
    }

    return false;
  }

  @override
  int get hashCode => id.hashCode;


  factory Journalist.fromJson(Map<String, dynamic> raw) => Journalist(
        id: raw['id'],
        name: raw['name'],
        link: Uri.parse(raw['link'] as String),
        location: raw['location'],
        links: (raw['links'] as Iterable? ?? const []).cast<String>(),
        image: raw['image'] != null ? Uri.parse(raw['image'] as String) : null,
        lastBioUpdate:
            DateTime.fromMillisecondsSinceEpoch(raw['last_bio_update'] ?? 0),
        classification: raw['classification'] != null
            ? JournalistClassification.fromJson(raw['classification']!)
            : null,
    tmpBio: null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'link': link.toString(),
        'image': image?.toString(),
        'location': location,
        'links': links,
        'last_bio_update': lastBioUpdate.millisecondsSinceEpoch,
        'classification': classification,
      };

  bool containsOutlet(String outlet) {
    final value = outlet.toLowerCase();

    return links.any((it) => it == value);
  }

  void updateLinks(Iterable<String> links) {
    this.links.clear();
    this.links.addAll(links);
  }
}

class ScrapedJournalist extends Journalist {
  final List<Article> articles;

  ScrapedJournalist({
    required super.id,
    required super.name,
    required super.link,
    required super.location,
    required super.links,
    required super.image,
    required super.lastBioUpdate,
    required super.classification,
    required super.tmpBio,
    required this.articles,
  });

  factory ScrapedJournalist.fromJson(Map<String, dynamic> raw) {
    final journalist = Journalist.fromJson(raw);

    return ScrapedJournalist(
      id: journalist.id,
      name: journalist.name,
      link: journalist.link,
      location: journalist.location,
      links: journalist.links.toList(growable: true),
      image: journalist.image,
      lastBioUpdate: journalist.lastBioUpdate,
      classification: journalist.classification,
      articles: (raw['articles'] as List? ?? const [])
          .map((it) => Article.fromJson(it))
          .toList(growable: true),
      tmpBio: null,
    );
  }

  factory ScrapedJournalist.fromJournalist(Journalist journalist,
          {required Iterable<Article> articles}) =>
      ScrapedJournalist(
        id: journalist.id,
        name: journalist.name,
        link: journalist.link,
        location: journalist.location,
        links: journalist.links.toList(),
        image: journalist.image,
        lastBioUpdate: journalist.lastBioUpdate,
        classification: journalist.classification,
        articles: articles.toList(growable: true),
        tmpBio: journalist.tmpBio,
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'articles': articles,
      };
}

class DescribedJournalist extends ScrapedJournalist {
  final String description;

  DescribedJournalist({
    required super.id,
    required super.name,
    required super.link,
    required super.location,
    required super.links,
    required super.image,
    required super.lastBioUpdate,
    required super.classification,
    required super.articles,
    required super.tmpBio,
    required this.description,
  });

  factory DescribedJournalist.fromJson(Map<String, dynamic> raw) {
    final journalist = ScrapedJournalist.fromJson(raw);

    return DescribedJournalist(
      id: journalist.id,
      name: journalist.name,
      link: journalist.link,
      location: journalist.location,
      links: journalist.links.toList(growable: true),
      image: journalist.image,
      lastBioUpdate: journalist.lastBioUpdate,
      classification: journalist.classification,
      articles: journalist.articles.toList(growable: true),
      description: raw['description'],
      tmpBio: null,
    );
  }

  factory DescribedJournalist.fromJournalist(
    Journalist journalist, {
    required Iterable<Article> articles,
    required String description,
  }) {
    final scrapedJournalist = ScrapedJournalist.fromJournalist(
      journalist,
      articles: articles,
    );

    return DescribedJournalist(
      id: scrapedJournalist.id,
      name: scrapedJournalist.name,
      link: scrapedJournalist.link,
      location: scrapedJournalist.location,
      links: scrapedJournalist.links.toList(growable: true),
      image: scrapedJournalist.image,
      lastBioUpdate: DateTime.now(),
      classification: scrapedJournalist.classification,
      articles: scrapedJournalist.articles.toList(growable: true),
      description: description,
      tmpBio: journalist.tmpBio,
    );
  }

  factory DescribedJournalist.withClassification(
    DescribedJournalist journalist, {
    required JournalistClassification classification,
  }) {
    return DescribedJournalist(
      id: journalist.id,
      name: journalist.name,
      link: journalist.link,
      location: journalist.location,
      links: journalist.links.toList(growable: true),
      image: journalist.image,
      lastBioUpdate: journalist.lastBioUpdate,
      classification: classification,
      articles: journalist.articles.toList(growable: true),
      description: journalist.description,
      tmpBio: journalist.tmpBio,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'description': description,
      };

  Map<String, dynamic> toIngestionJson() => {
        'id': id,
        'name': name,
        'link': link.toString(),
        'image': image?.toString(),
        'location': location,
        'links': links,
        'description': description,
        'last_bio_update': lastBioUpdate.millisecondsSinceEpoch,
        'classification': classification?.toIngestionValue(),
      };

  void swapArticles(List<Article> value) {
    articles.clear();
    articles.addAll(value);
  }
}
