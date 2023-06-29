import 'package:dazzle_domain/dazzle_domain.dart';

class Journalist {
  final String id;
  final Uri link;
  final Uri articleLink;
  final String name;
  final Uri? image;
  final String? location;
  final List<String> links;
  final DateTime lastBioUpdate;
  final Description? pendingDescription;
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
    required this.pendingDescription,
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
        pendingDescription: null,
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
    required super.pendingDescription,
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
      pendingDescription: null,
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
    required super.link,
    required super.location,
    required super.links,
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
      link: journalist.link,
      location: journalist.location,
      links: journalist.links.toList(growable: true),
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
      link: scrapedJournalist.link,
      location: scrapedJournalist.location,
      links: scrapedJournalist.links.toList(growable: true),
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
      link: journalist.link,
      location: journalist.location,
      links: journalist.links.toList(growable: true),
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
        'name': name,
        'link': link.toString(),
        'image': image?.toString(),
        'location': location,
        'links': links,
        'title': description.title,
        'description_short': description.short,
        'description_long': description.long,
        'last_bio_update': lastBioUpdate.millisecondsSinceEpoch,
        'classification': classification?.toIngestionValue(),
      };
}

class Description {
  final String title;
  final String long;
  final String short;

  const Description({
    required this.title,
    required this.short,
    required this.long,
  });

  factory Description.fromJson(Map<String, dynamic> raw) => Description(
        title: raw['title'],
        short: raw['short'],
        long: raw['long'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'short': short,
        'long': long,
      };
}
