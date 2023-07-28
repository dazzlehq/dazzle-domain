import 'package:dazzle_domain/dazzle_domain.dart';

class Journalist {
  final String id;
  final Outlet outlet;
  final String name;
  final Uri? image;
  final String? location;
  final DateTime lastBioUpdate;
  final Description? pendingDescription;
  final JournalistClassification? classification;

  Journalist({
    required this.id,
    required this.name,
    required this.outlet,
    required this.location,
    required this.image,
    required this.lastBioUpdate,
    required this.classification,
    required this.pendingDescription,
  });

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
        outlet: Outlet.fromJson(raw['outlet']),
        location: raw['location'],
        image: raw['image'] != null ? Uri.parse(raw['image'] as String) : null,
        lastBioUpdate:
            DateTime.fromMillisecondsSinceEpoch(raw['last_bio_update'] ?? 0),
        classification: raw['classification'] != null
            ? JournalistClassification.fromJson(raw['classification']!)
            : null,
        pendingDescription: null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'outlet': outlet,
        'image': image?.toString(),
        'location': location,
        'last_bio_update': lastBioUpdate.millisecondsSinceEpoch,
        'classification': classification,
      };
}

class ScrapedJournalist extends Journalist {
  final List<Article> articles;

  ScrapedJournalist({
    required super.id,
    required super.name,
    required super.outlet,
    required super.location,
    required super.image,
    required super.lastBioUpdate,
    required super.classification,
    required super.pendingDescription,
    required this.articles,
  });

  factory ScrapedJournalist.fromJson(Map<String, dynamic> raw) {
    final journalist = Journalist.fromJson(raw);

    return ScrapedJournalist(
      id: journalist.id,
      name: journalist.name,
      outlet: journalist.outlet,
      location: journalist.location,
      image: journalist.image,
      lastBioUpdate: journalist.lastBioUpdate,
      classification: journalist.classification,
      articles: (raw['articles'] as List? ?? const [])
          .map((it) => Article.fromJson(it))
          .toList(growable: true),
      pendingDescription: null,
    );
  }

  factory ScrapedJournalist.fromJournalist(Journalist journalist,
          {required Iterable<Article> articles}) =>
      ScrapedJournalist(
        id: journalist.id,
        name: journalist.name,
        outlet: journalist.outlet,
        location: journalist.location,
        image: journalist.image,
        lastBioUpdate: journalist.lastBioUpdate,
        classification: journalist.classification,
        articles: articles.toList(growable: true),
        pendingDescription: journalist.pendingDescription,
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'articles': articles,
      };

  ScrapedJournalist withUpdatedArticles(List<Article> articles) =>
      ScrapedJournalist.fromJournalist(this, articles: articles);

  void swapArticles(List<Article> value) {
    articles.clear();
    articles.addAll(value);
  }
}

class DescribedJournalist extends ScrapedJournalist {
  final Description description;

  DescribedJournalist({
    required super.id,
    required super.name,
    required super.outlet,
    required super.location,
    required super.image,
    required super.lastBioUpdate,
    required super.classification,
    required super.articles,
    required super.pendingDescription,
    required this.description,
  });

  factory DescribedJournalist.fromJson(Map<String, dynamic> raw) {
    final journalist = ScrapedJournalist.fromJson(raw);

    return DescribedJournalist(
      id: journalist.id,
      name: journalist.name,
      outlet: journalist.outlet,
      location: journalist.location,
      image: journalist.image,
      lastBioUpdate: journalist.lastBioUpdate,
      classification: journalist.classification,
      articles: journalist.articles.toList(growable: true),
      description: Description.fromJson(raw['description'] ?? const {}),
      pendingDescription: null,
    );
  }

  factory DescribedJournalist.fromJournalist(
    Journalist journalist, {
    required Iterable<Article> articles,
    required Description description,
  }) {
    final scrapedJournalist = ScrapedJournalist.fromJournalist(
      journalist,
      articles: articles,
    );

    return DescribedJournalist(
      id: scrapedJournalist.id,
      name: scrapedJournalist.name,
      outlet: scrapedJournalist.outlet,
      location: scrapedJournalist.location,
      image: scrapedJournalist.image,
      lastBioUpdate: DateTime.now(),
      classification: scrapedJournalist.classification,
      articles: scrapedJournalist.articles.toList(growable: true),
      description: description,
      pendingDescription: journalist.pendingDescription,
    );
  }

  factory DescribedJournalist.withClassification(
    DescribedJournalist journalist, {
    required JournalistClassification classification,
  }) {
    return DescribedJournalist(
      id: journalist.id,
      name: journalist.name,
      outlet: journalist.outlet,
      location: journalist.location,
      image: journalist.image,
      lastBioUpdate: journalist.lastBioUpdate,
      classification: classification,
      articles: journalist.articles.toList(growable: true),
      description: journalist.description,
      pendingDescription: journalist.pendingDescription,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'description': description,
      };

  Map<String, dynamic> toIngestionJson() => {
        'id': id,
        'group_name': 'JOU',
        'name': name,
        'outlet_authority': outlet.authority,
        'outlet_name': outlet.name,
        'image': image?.toString(),
        'location': location,
        'title': description.title,
        'article_types': description.articleTypes,
        'description_short': description.short,
        'description_long': description.long,
        'classification': classification?.toIngestionValue(),
      };
}

class Description {
  final String title;
  final String long;
  final String short;
  final List<String> articleTypes;

  const Description({
    required this.title,
    required this.short,
    required this.long,
    required this.articleTypes,
  });

  factory Description.fromJson(Map<String, dynamic> raw) => Description(
        title: raw['title'],
        short: raw['short'],
        long: raw['long'],
        articleTypes: (raw['article_types'] as List? ?? const [])
            .cast<String>()
            .toList(growable: false),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'short': short,
        'long': long,
        'article_types': articleTypes,
      };
}
