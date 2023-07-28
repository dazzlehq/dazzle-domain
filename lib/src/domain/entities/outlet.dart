import 'package:dazzle_domain/dazzle_domain.dart';

class Outlet {
  final String id;
  final String name;
  final String url;
  final String homePage;
  final String authority;
  final int rank;
  final List<String> journalists;
  final String metaScope;
  final String metaLang;
  final String metaCountry;

  const Outlet({
    required this.id,
    required this.name,
    required this.url,
    required this.homePage,
    required this.authority,
    required this.rank,
    required this.journalists,
    required this.metaScope,
    required this.metaLang,
    required this.metaCountry,
  });

  @override
  bool operator ==(Object other) {
    if (other is Outlet) {
      return other.hashCode == hashCode;
    }

    return false;
  }

  @override
  int get hashCode => id.hashCode;

  Outlet withUpdatedJournalists(List<Uri> journalists) => Outlet(
        id: id,
        name: name,
        url: url,
        homePage: homePage,
        authority: authority,
        rank: rank,
        journalists:
            journalists.map((it) => it.toString()).toList(growable: false),
        metaScope: metaScope,
        metaLang: metaLang,
        metaCountry: metaCountry,
      );

  factory Outlet.fromJson(Map<String, dynamic> raw) => Outlet(
        id: raw['id'],
        name: raw['name'],
        url: raw['url'],
        homePage: raw['home_page'],
        authority: raw['authority'],
        rank: raw['similar_web_rank'],
        journalists: (raw['journalists'] as Iterable)
            .cast<String>()
            .toList(growable: false),
        metaScope: raw['meta_scope'],
        metaLang: raw['meta_lang'],
        metaCountry: raw['meta_country'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'home_page': homePage,
        'authority': authority,
        'similar_web_rank': rank,
        'journalists': journalists,
        'meta_scope': metaScope,
        'meta_lang': metaLang,
        'meta_country': metaCountry,
      };
}

class ScrapedOutlet extends Outlet {
  final List<DescribedJournalist> scrapedJournalists;

  const ScrapedOutlet({
    required super.id,
    required super.name,
    required super.url,
    required super.homePage,
    required super.authority,
    required super.rank,
    required super.journalists,
    required super.metaScope,
    required super.metaLang,
    required super.metaCountry,
    required this.scrapedJournalists,
  });

  factory ScrapedOutlet.fromOutlet(
          Outlet outlet, List<DescribedJournalist> journalists) =>
      ScrapedOutlet(
        id: outlet.id,
        name: outlet.name,
        url: outlet.url,
        homePage: outlet.homePage,
        authority: outlet.authority,
        rank: outlet.rank,
        journalists: outlet.journalists,
        metaScope: outlet.metaScope,
        metaLang: outlet.metaLang,
        metaCountry: outlet.metaCountry,
        scrapedJournalists: journalists,
      );

  factory ScrapedOutlet.fromJson(Map<String, dynamic> raw) {
    final outlet = Outlet.fromJson(raw);

    return ScrapedOutlet(
      id: outlet.id,
      name: outlet.name,
      url: outlet.url,
      homePage: outlet.homePage,
      authority: outlet.authority,
      rank: outlet.rank,
      journalists: outlet.journalists,
      metaScope: outlet.metaScope,
      metaLang: outlet.metaLang,
      metaCountry: outlet.metaCountry,
      scrapedJournalists: (raw['scraped_journalists'] as Iterable)
          .cast<Map>()
          .map((it) => DescribedJournalist.fromJson(it.cast<String, dynamic>()))
          .toList(growable: false),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'home_page': homePage,
        'authority': authority,
        'similar_web_rank': rank,
        'meta_scope': metaScope,
        'meta_lang': metaLang,
        'meta_country': metaCountry,
        'scraped_journalists': scrapedJournalists,
      };
}

class DescribedOutlet extends ScrapedOutlet {
  final String description;

  const DescribedOutlet({
    required super.id,
    required super.name,
    required super.url,
    required super.homePage,
    required super.authority,
    required super.rank,
    required super.journalists,
    required super.metaScope,
    required super.metaLang,
    required super.metaCountry,
    required super.scrapedJournalists,
    required this.description,
  });

  factory DescribedOutlet.fromScraped(
          ScrapedOutlet outlet, String description) =>
      DescribedOutlet(
        id: outlet.id,
        name: outlet.name,
        url: outlet.url,
        homePage: outlet.homePage,
        authority: outlet.authority,
        rank: outlet.rank,
        journalists: outlet.journalists,
        metaScope: outlet.metaScope,
        metaLang: outlet.metaLang,
        metaCountry: outlet.metaCountry,
        scrapedJournalists: outlet.scrapedJournalists,
        description: description,
      );

  factory DescribedOutlet.fromJson(Map<String, dynamic> raw) {
    final outlet = ScrapedOutlet.fromJson(raw);

    return DescribedOutlet(
      id: outlet.id,
      name: outlet.name,
      url: outlet.url,
      homePage: outlet.homePage,
      authority: outlet.authority,
      rank: outlet.rank,
      journalists: outlet.journalists,
      metaScope: outlet.metaScope,
      metaLang: outlet.metaLang,
      metaCountry: outlet.metaCountry,
      scrapedJournalists: outlet.scrapedJournalists,
      description: raw['description'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'home_page': homePage,
        'authority': authority,
        'similar_web_rank': rank,
        'meta_scope': metaScope,
        'meta_lang': metaLang,
        'meta_country': metaCountry,
        'scraped_journalists': scrapedJournalists,
        'description': description,
      };

  Map<String, dynamic> toIngestionJson() => {
        'id': id,
        'group_name': 'OUT',
        'name': name,
        'home_page': homePage,
        'authority': authority,
        'description': description,
        'similar_web_rank': rank,
        'journalist_id': scrapedJournalists
            .toSet()
            .map((it) => it.id)
            .toList(growable: false),
        'meta_num_writers': journalists.toSet().length,
        'meta_scope': metaScope,
        'meta_lang': metaLang,
        'meta_country': metaCountry,
      };
}
