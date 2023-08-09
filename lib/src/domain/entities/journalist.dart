import 'package:dazzle_domain/dazzle_domain.dart';

class Journalist {
  final String ident;
  final String id;
  final Outlet outlet;
  final String name;
  final String? location;
  final DateTime lastBioUpdate;
  final Description? pendingDescription;
  final JournalistClassification? classification;

  Journalist({
    required this.ident,
    required this.id,
    required this.name,
    required this.outlet,
    required this.location,
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
        ident: '',
        id: raw['id'],
        name: raw['name'],
        outlet: Outlet.fromJson(raw['outlet']),
        location: raw['location'],
        lastBioUpdate:
            DateTime.fromMillisecondsSinceEpoch(raw['last_bio_update'] ?? 0),
        classification: raw['classification'] != null
            ? JournalistClassification.fromJson(raw['classification']!)
            : null,
        pendingDescription: null,
      );

  factory Journalist.fromLegacyJson({
    required String ident,
    required Outlet outlet,
    required Map<String, dynamic> raw,
  }) {
    final profiles = (raw['profiles'] as List).cast<Map>();
    final profile = (profiles.firstWhere((it) => it['outlet_id'] == outlet.id,
        orElse: () => const <String, dynamic>{})).cast<String, dynamic>();

    return Journalist(
      ident: ident,
      id: profile['id'],
      name: raw['name'],
      outlet: outlet,
      location: raw['muckrack_location'],
      lastBioUpdate: DateTime.fromMillisecondsSinceEpoch(
          profile['last_bio_generation_date'] ?? 0),
      classification: profile['classification'] != null
          ? JournalistClassification.fromJson(profile['classification']!)
          : null,
      pendingDescription: profile['bio'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'outlet': outlet,
        'location': location,
        'last_bio_update': lastBioUpdate.millisecondsSinceEpoch,
        'classification': classification,
      };
}

class ScrapedJournalist extends Journalist {
  final List<Article> articles;
  final SocialMedia socialMedia;

  ScrapedJournalist({
    required super.ident,
    required super.id,
    required super.name,
    required super.outlet,
    required super.location,
    required super.lastBioUpdate,
    required super.classification,
    required super.pendingDescription,
    required this.articles,
    required this.socialMedia,
  });

  factory ScrapedJournalist.fromJson(Map<String, dynamic> raw) {
    final journalist = Journalist.fromJson(raw);

    return ScrapedJournalist(
      ident: journalist.ident,
      id: journalist.id,
      name: journalist.name,
      outlet: journalist.outlet,
      location: journalist.location,
      lastBioUpdate: journalist.lastBioUpdate,
      classification: journalist.classification,
      articles: (raw['articles'] as List? ?? const [])
          .map((it) => Article.fromJson(it))
          .toList(growable: true),
      socialMedia: SocialMedia.fromJson(
          (raw['social_media'] as Map).cast<String, dynamic>()),
      pendingDescription: null,
    );
  }

  factory ScrapedJournalist.fromJournalist(
    Journalist journalist, {
    required Iterable<Article> articles,
    required SocialMedia socialMedia,
  }) =>
      ScrapedJournalist(
        ident: journalist.ident,
        id: journalist.id,
        name: journalist.name,
        outlet: journalist.outlet,
        location: journalist.location,
        lastBioUpdate: journalist.lastBioUpdate,
        classification: journalist.classification,
        articles: articles.toList(growable: true),
        socialMedia: socialMedia,
        pendingDescription: journalist.pendingDescription,
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'articles': articles,
        'social_media': socialMedia,
      };

  ScrapedJournalist withUpdatedArticles(List<Article> articles) =>
      ScrapedJournalist.fromJournalist(
        this,
        articles: articles,
        socialMedia: socialMedia,
      );

  void swapArticles(List<Article> value) {
    articles.clear();
    articles.addAll(value);
  }
}

class DescribedJournalist extends ScrapedJournalist {
  final Description description;

  DescribedJournalist({
    required super.ident,
    required super.id,
    required super.name,
    required super.outlet,
    required super.location,
    required super.lastBioUpdate,
    required super.classification,
    required super.articles,
    required super.socialMedia,
    required super.pendingDescription,
    required this.description,
  });

  factory DescribedJournalist.fromJson(Map<String, dynamic> raw) {
    final journalist = ScrapedJournalist.fromJson(raw);

    return DescribedJournalist(
      ident: journalist.ident,
      id: journalist.id,
      name: journalist.name,
      outlet: journalist.outlet,
      location: journalist.location,
      lastBioUpdate: journalist.lastBioUpdate,
      classification: journalist.classification,
      articles: journalist.articles.toList(growable: true),
      socialMedia: journalist.socialMedia,
      description: Description.fromJson(raw['description'] ?? const {}),
      pendingDescription: null,
    );
  }

  factory DescribedJournalist.fromJournalist(
    Journalist journalist, {
    required Iterable<Article> articles,
    required SocialMedia socialMedia,
    required Description description,
  }) {
    final scrapedJournalist = ScrapedJournalist.fromJournalist(
      journalist,
      articles: articles,
      socialMedia: socialMedia,
    );

    return DescribedJournalist(
      ident: scrapedJournalist.ident,
      id: scrapedJournalist.id,
      name: scrapedJournalist.name,
      outlet: scrapedJournalist.outlet,
      location: scrapedJournalist.location,
      lastBioUpdate: DateTime.now(),
      classification: scrapedJournalist.classification,
      articles: scrapedJournalist.articles.toList(growable: true),
      socialMedia: scrapedJournalist.socialMedia,
      description: description,
      pendingDescription: journalist.pendingDescription,
    );
  }

  factory DescribedJournalist.withClassification(
    DescribedJournalist journalist, {
    required JournalistClassification classification,
  }) {
    return DescribedJournalist(
      ident: journalist.ident,
      id: journalist.id,
      name: journalist.name,
      outlet: journalist.outlet,
      location: journalist.location,
      lastBioUpdate: journalist.lastBioUpdate,
      classification: classification,
      articles: journalist.articles.toList(growable: true),
      socialMedia: journalist.socialMedia,
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
        'location': location,
        'title': description.title,
        'article_types': description.articleTypes,
        'description_short': description.short,
        'description_long': description.long,
        'classification': classification?.toIngestionValue(),
        'social_linkedin': socialMedia.linkedIn?.toString(),
        'social_twitter': socialMedia.twitter?.toString(),
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

class SocialMedia {
  final Uri? linkedIn;
  final Uri? twitter;

  const SocialMedia({
    required this.linkedIn,
    required this.twitter,
  });

  const SocialMedia.empty()
      : linkedIn = null,
        twitter = null;

  factory SocialMedia.fromJson(Map<String, dynamic> raw) => SocialMedia(
        linkedIn: raw['linkedin'] != null
            ? Uri.parse(raw['linkedin'] as String)
            : null,
        twitter:
            raw['twitter'] != null ? Uri.parse(raw['twitter'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'linkedin': linkedIn?.toString(),
        'twitter': twitter?.toString(),
      };
}
