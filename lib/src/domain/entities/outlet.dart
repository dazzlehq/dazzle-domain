class Outlet {
  final String id;
  final String name;
  final String homePage;
  final String authority;
  final String metaScope;
  final String metaLang;
  final String metaCountry;
  final String monthlyVisitors;

  const Outlet({
    required this.id,
    required this.name,
    required this.homePage,
    required this.authority,
    required this.metaScope,
    required this.metaLang,
    required this.metaCountry,
    required this.monthlyVisitors,
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
        homePage: homePage,
        authority: authority,
        metaScope: metaScope,
        metaLang: metaLang,
        metaCountry: metaCountry,
        monthlyVisitors: monthlyVisitors,
      );

  factory Outlet.fromJson(Map<String, dynamic> raw) => Outlet(
        id: raw['id'],
        name: raw['name'],
        homePage: raw['home_page'],
        authority: raw['authority'],
        metaScope: raw['meta_scope'] ?? '',
        metaLang: raw['meta_lang'] ?? '',
        metaCountry: raw['meta_country'] ?? '',
        monthlyVisitors: raw['similar_web_rank'] ?? -1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'home_page': homePage,
        'authority': authority,
        'meta_scope': metaScope,
        'meta_lang': metaLang,
        'meta_country': metaCountry,
        'similar_web_rank': monthlyVisitors,
      };
}

class DescribedOutlet extends Outlet {
  final String description;

  const DescribedOutlet({
    required super.id,
    required super.name,
    required super.homePage,
    required super.authority,
    required super.metaScope,
    required super.metaLang,
    required super.metaCountry,
    required super.monthlyVisitors,
    required this.description,
  });

  factory DescribedOutlet.fromJson(Map<String, dynamic> raw) {
    final outlet = Outlet.fromJson(raw);

    return DescribedOutlet(
      id: outlet.id,
      name: outlet.name,
      homePage: outlet.homePage,
      authority: outlet.authority,
      metaScope: outlet.metaScope,
      metaLang: outlet.metaLang,
      metaCountry: outlet.metaCountry,
      monthlyVisitors: outlet.monthlyVisitors,
      description: raw['description'] ?? 'No description yet!',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'home_page': homePage,
        'authority': authority,
        'meta_scope': metaScope,
        'meta_lang': metaLang,
        'meta_country': metaCountry,
        'description': description,
        'similar_web_rank': monthlyVisitors,
      };
}
