class Outlet {
  final String id;
  final String name;
  final String homePage;
  final String authority;
  final String metaScope;
  final String metaLang;
  final String metaCountry;

  const Outlet({
    required this.id,
    required this.name,
    required this.homePage,
    required this.authority,
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
        homePage: homePage,
        authority: authority,
        metaScope: metaScope,
        metaLang: metaLang,
        metaCountry: metaCountry,
      );

  factory Outlet.fromJson(Map<String, dynamic> raw) => Outlet(
        id: raw['id'],
        name: raw['name'],
        homePage: raw['home_page'],
        authority: raw['authority'],
        metaScope: raw['meta_scope'],
        metaLang: raw['meta_lang'],
        metaCountry: raw['meta_country'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'home_page': homePage,
        'authority': authority,
        'meta_scope': metaScope,
        'meta_lang': metaLang,
        'meta_country': metaCountry,
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
      description: raw['description'],
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
      };
}
