import 'dart:convert';

class JournalistClassification {
  final CompanyTypeClassification companyType;
  final GeoRegionClassification geoRegion;
  final ArticleTypeClassification articleType;

  const JournalistClassification({
    required this.companyType,
    required this.geoRegion,
    required this.articleType,
  });

  factory JournalistClassification.fromJson(Map<String, dynamic> raw) =>
      JournalistClassification(
        companyType: CompanyTypeClassification.fromJson(raw['company_type']),
        geoRegion: GeoRegionClassification.fromJson(raw['geographical_region']),
        articleType: ArticleTypeClassification.fromJson(raw['article_type']),
      );

  factory JournalistClassification.fromBase64(String data) =>
      JournalistClassification.fromJson(const JsonDecoder()
          .convert(String.fromCharCodes(const Base64Decoder().convert(data))));

  Map<String, dynamic> toJson() => {
        'company_type': companyType,
        'geographical_region': geoRegion,
        'article_type': articleType,
      };

  String toIngestionValue() => const Base64Codec()
      .encode(const JsonEncoder().convert(toJson()).codeUnits);
}

enum CompanyType {
  startup(objectName: 'startup'),
  smb(objectName: 'smb'),
  enterprise(objectName: 'enterprise'),
  other(objectName: 'other'),
  undetermined(objectName: 'undetermined');

  final String objectName;

  const CompanyType({
    required this.objectName,
  });

  factory CompanyType.from(String raw) {
    switch (raw) {
      case 'startup':
        return startup;
      case 'smb':
        return smb;
      case 'enterprise':
        return enterprise;
      case 'undetermined':
        return undetermined;
      default:
        return other;
    }
  }
}

enum GeoRegion {
  europe(objectName: 'europe'),
  uk(objectName: 'uk'),
  us(objectName: 'us'),
  canada(objectName: 'canada'),
  latinAmerica(objectName: 'latin_america'),
  asiaPacific(objectName: 'asia_pacific'),
  oceania(objectName: 'oceania'),
  mena(objectName: 'mena'),
  subSaharan(objectName: 'sub_saharan'),
  other(objectName: 'other'),
  undetermined(objectName: 'undetermined');

  final String objectName;

  const GeoRegion({
    required this.objectName,
  });

  factory GeoRegion.from(String raw) {
    switch (raw) {
      case 'europe':
        return europe;
      case 'uk':
        return uk;
      case 'us':
        return us;
      case 'canada':
        return canada;
      case 'latin_america':
        return latinAmerica;
      case 'asia_pacific':
        return asiaPacific;
      case 'oceania':
        return oceania;
      case 'mena':
        return mena;
      case 'sub_saharan':
        return subSaharan;
      case 'undetermined':
        return undetermined;
      default:
        return other;
    }
  }
}

enum ArticleType {
  industryTrends(objectName: 'industry_trends'),
  featureArticle(objectName: 'feature_article'),
  review(objectName: 'review'),
  productLaunchOrUpdate(objectName: 'product_launch_or_update'),
  funding(objectName: 'funding'),
  partnership(objectName: 'partnership'),
  acquisition(objectName: 'acquisition'),
  expansion(objectName: 'expansion'),
  explainer(objectName: 'explainer'),
  howTo(objectName: 'how_to'),
  roundup(objectName: 'roundup'),
  interview(objectName: 'interview'),
  profile(objectName: 'profile'),
  event(objectName: 'event'),
  thoughtLeadership(objectName: 'thought_leadership'),
  opinion(objectName: 'opinion'),
  satire(objectName: 'satire'),
  other(objectName: 'other'),
  undetermined(objectName: 'undetermined');

  final String objectName;

  const ArticleType({
    required this.objectName,
  });

  factory ArticleType.from(String raw) {
    switch (raw) {
      case 'industry_trends':
        return industryTrends;
      case 'feature_article':
        return featureArticle;
      case 'review':
        return review;
      case 'product_launch_or_update':
        return productLaunchOrUpdate;
      case 'funding':
        return funding;
      case 'partnership':
        return partnership;
      case 'acquisition':
        return acquisition;
      case 'expansion':
        return expansion;
      case 'explainer':
        return explainer;
      case 'how_to':
        return howTo;
      case 'roundup':
        return roundup;
      case 'interview':
        return interview;
      case 'profile':
        return profile;
      case 'event':
        return event;
      case 'thought_leadership':
        return thoughtLeadership;
      case 'opinion':
        return opinion;
      case 'satire':
        return satire;
      case 'undetermined':
        return undetermined;
      default:
        return other;
    }
  }
}

class CompanyTypeClassification {
  final int startup, smb, enterprise, other, undetermined;

  int get totalCount => startup + smb + enterprise + other + undetermined;

  const CompanyTypeClassification({
    required this.startup,
    required this.smb,
    required this.enterprise,
    required this.other,
    required this.undetermined,
  });

  const CompanyTypeClassification.empty()
      : startup = 0,
        smb = 0,
        enterprise = 0,
        other = 0,
        undetermined = 0;

  factory CompanyTypeClassification.fromJson(Map<String, dynamic> raw) =>
      CompanyTypeClassification(
        startup: raw[CompanyType.startup.objectName] ?? 0,
        smb: raw[CompanyType.smb.objectName] ?? 0,
        enterprise: raw[CompanyType.enterprise.objectName] ?? 0,
        other: raw[CompanyType.other.objectName] ?? 0,
        undetermined: raw[CompanyType.undetermined.objectName] ?? 0,
      );

  double diff(CompanyType type, double range) {
    if (totalCount == 0) return .0;

    int count = 0;

    switch (type) {
      case CompanyType.startup:
        count = startup;
        break;
      case CompanyType.smb:
        count = smb;
        break;
      case CompanyType.enterprise:
        count = enterprise;
        break;
      default:
        count = other + undetermined;
        break;
    }

    return (range - (count / totalCount)).clamp(.0, 1.0);
  }

  CompanyTypeClassification incremented(CompanyType companyType) {
    switch (companyType) {
      case CompanyType.startup:
        return CompanyTypeClassification(
          startup: startup + 1,
          smb: smb,
          enterprise: enterprise,
          other: other,
          undetermined: undetermined,
        );
      case CompanyType.smb:
        return CompanyTypeClassification(
          startup: startup,
          smb: smb + 1,
          enterprise: enterprise,
          other: other,
          undetermined: undetermined,
        );
      case CompanyType.enterprise:
        return CompanyTypeClassification(
          startup: startup,
          smb: smb,
          enterprise: enterprise + 1,
          other: other,
          undetermined: undetermined,
        );
      case CompanyType.other:
        return CompanyTypeClassification(
          startup: startup,
          smb: smb,
          enterprise: enterprise,
          other: other + 1,
          undetermined: undetermined,
        );
      case CompanyType.undetermined:
        return CompanyTypeClassification(
          startup: startup,
          smb: smb,
          enterprise: enterprise,
          other: other,
          undetermined: undetermined + 1,
        );
    }
  }

  Map<String, dynamic> toJson() => {
        CompanyType.startup.objectName: startup,
        CompanyType.smb.objectName: smb,
        CompanyType.enterprise.objectName: enterprise,
        CompanyType.other.objectName: other,
        CompanyType.undetermined.objectName: undetermined,
      };
}

// Europe,UK,US,Canada,Latin America,Asia-Pacific,Oceania,MENA,Sub-Saharan
class GeoRegionClassification {
  final int europe,
      uk,
      us,
      canada,
      latinAmerica,
      asiaPacific,
      oceania,
      mena,
      subSaharan,
      other,
      undetermined;

  int get totalCount =>
      europe +
      uk +
      us +
      canada +
      latinAmerica +
      asiaPacific +
      oceania +
      mena +
      subSaharan +
      other +
      undetermined;

  const GeoRegionClassification({
    required this.europe,
    required this.uk,
    required this.us,
    required this.canada,
    required this.latinAmerica,
    required this.asiaPacific,
    required this.oceania,
    required this.mena,
    required this.subSaharan,
    required this.other,
    required this.undetermined,
  });

  const GeoRegionClassification.empty()
      : europe = 0,
        uk = 0,
        us = 0,
        canada = 0,
        latinAmerica = 0,
        asiaPacific = 0,
        oceania = 0,
        mena = 0,
        subSaharan = 0,
        other = 0,
        undetermined = 0;

  factory GeoRegionClassification.fromJson(Map<String, dynamic> raw) =>
      GeoRegionClassification(
        europe: raw[GeoRegion.europe.objectName] ?? 0,
        uk: raw[GeoRegion.uk.objectName] ?? 0,
        us: raw[GeoRegion.us.objectName] ?? 0,
        canada: raw[GeoRegion.canada.objectName] ?? 0,
        latinAmerica: raw[GeoRegion.latinAmerica.objectName] ?? 0,
        asiaPacific: raw[GeoRegion.asiaPacific.objectName] ?? 0,
        oceania: raw[GeoRegion.oceania.objectName] ?? 0,
        mena: raw[GeoRegion.mena.objectName] ?? 0,
        subSaharan: raw[GeoRegion.subSaharan.objectName] ?? 0,
        other: raw[GeoRegion.other.objectName] ?? 0,
        undetermined: raw[GeoRegion.undetermined.objectName] ?? 0,
      );

  List<GeoRegion> topChoices(double percentage) {
    final t = totalCount;

    if (t == 0) return const [GeoRegion.undetermined];

    return [
      if (europe >= t * percentage) GeoRegion.europe,
      if (uk >= t * percentage) GeoRegion.uk,
      if (us >= t * percentage) GeoRegion.us,
      if (canada >= t * percentage) GeoRegion.canada,
      if (latinAmerica >= t * percentage) GeoRegion.latinAmerica,
      if (asiaPacific >= t * percentage) GeoRegion.asiaPacific,
      if (oceania >= t * percentage) GeoRegion.oceania,
      if (mena >= t * percentage) GeoRegion.mena,
      if (subSaharan >= t * percentage) GeoRegion.subSaharan,
    ];
  }

  double diff(GeoRegion type, double range) {
    if (totalCount == 0) return .0;

    int count = 0;

    switch (type) {
      case GeoRegion.europe:
        count = europe;
        break;
      case GeoRegion.uk:
        count = uk;
        break;
      case GeoRegion.us:
        count = us;
        break;
      case GeoRegion.canada:
        count = canada;
        break;
      case GeoRegion.latinAmerica:
        count = latinAmerica;
        break;
      case GeoRegion.asiaPacific:
        count = asiaPacific;
        break;
      case GeoRegion.oceania:
        count = oceania;
        break;
      case GeoRegion.mena:
        count = mena;
        break;
      case GeoRegion.subSaharan:
        count = subSaharan;
        break;
      default:
        count = other + undetermined;
        break;
    }

    return (range - (count / totalCount)).clamp(.0, 1.0);
  }

  GeoRegionClassification incremented(GeoRegion geoRegion) {
    switch (geoRegion) {
      case GeoRegion.europe:
        return GeoRegionClassification(
          europe: europe + 1,
          uk: uk,
          us: us,
          canada: canada,
          latinAmerica: latinAmerica,
          asiaPacific: asiaPacific,
          oceania: oceania,
          mena: mena,
          subSaharan: subSaharan,
          other: other,
          undetermined: undetermined,
        );
      case GeoRegion.uk:
        return GeoRegionClassification(
          europe: europe,
          uk: uk + 1,
          us: us,
          canada: canada,
          latinAmerica: latinAmerica,
          asiaPacific: asiaPacific,
          oceania: oceania,
          mena: mena,
          subSaharan: subSaharan,
          other: other,
          undetermined: undetermined,
        );
      case GeoRegion.us:
        return GeoRegionClassification(
          europe: europe,
          uk: uk,
          us: us + 1,
          canada: canada,
          latinAmerica: latinAmerica,
          asiaPacific: asiaPacific,
          oceania: oceania,
          mena: mena,
          subSaharan: subSaharan,
          other: other,
          undetermined: undetermined,
        );
      case GeoRegion.canada:
        return GeoRegionClassification(
          europe: europe,
          uk: uk,
          us: us,
          canada: canada + 1,
          latinAmerica: latinAmerica,
          asiaPacific: asiaPacific,
          oceania: oceania,
          mena: mena,
          subSaharan: subSaharan,
          other: other,
          undetermined: undetermined,
        );
      case GeoRegion.latinAmerica:
        return GeoRegionClassification(
          europe: europe,
          uk: uk,
          us: us,
          canada: canada,
          latinAmerica: latinAmerica + 1,
          asiaPacific: asiaPacific,
          oceania: oceania,
          mena: mena,
          subSaharan: subSaharan,
          other: other,
          undetermined: undetermined,
        );
      case GeoRegion.asiaPacific:
        return GeoRegionClassification(
          europe: europe,
          uk: uk,
          us: us,
          canada: canada,
          latinAmerica: latinAmerica,
          asiaPacific: asiaPacific + 1,
          oceania: oceania,
          mena: mena,
          subSaharan: subSaharan,
          other: other,
          undetermined: undetermined,
        );
      case GeoRegion.oceania:
        return GeoRegionClassification(
          europe: europe,
          uk: uk,
          us: us,
          canada: canada,
          latinAmerica: latinAmerica,
          asiaPacific: asiaPacific,
          oceania: oceania + 1,
          mena: mena,
          subSaharan: subSaharan,
          other: other,
          undetermined: undetermined,
        );
      case GeoRegion.mena:
        return GeoRegionClassification(
          europe: europe,
          uk: uk,
          us: us,
          canada: canada,
          latinAmerica: latinAmerica,
          asiaPacific: asiaPacific,
          oceania: oceania,
          mena: mena + 1,
          subSaharan: subSaharan,
          other: other,
          undetermined: undetermined,
        );
      case GeoRegion.subSaharan:
        return GeoRegionClassification(
          europe: europe,
          uk: uk,
          us: us,
          canada: canada,
          latinAmerica: latinAmerica,
          asiaPacific: asiaPacific,
          oceania: oceania,
          mena: mena,
          subSaharan: subSaharan + 1,
          other: other,
          undetermined: undetermined,
        );
      case GeoRegion.other:
        return GeoRegionClassification(
          europe: europe,
          uk: uk,
          us: us,
          canada: canada,
          latinAmerica: latinAmerica,
          asiaPacific: asiaPacific,
          oceania: oceania,
          mena: mena,
          subSaharan: subSaharan,
          other: other + 1,
          undetermined: undetermined,
        );
      case GeoRegion.undetermined:
        return GeoRegionClassification(
          europe: europe,
          uk: uk,
          us: us,
          canada: canada,
          latinAmerica: latinAmerica,
          asiaPacific: asiaPacific,
          oceania: oceania,
          mena: mena,
          subSaharan: subSaharan,
          other: other,
          undetermined: undetermined + 1,
        );
    }
  }

  Map<String, dynamic> toJson() => {
        GeoRegion.europe.objectName: europe,
        GeoRegion.uk.objectName: uk,
        GeoRegion.us.objectName: us,
        GeoRegion.canada.objectName: canada,
        GeoRegion.latinAmerica.objectName: latinAmerica,
        GeoRegion.asiaPacific.objectName: asiaPacific,
        GeoRegion.oceania.objectName: oceania,
        GeoRegion.mena.objectName: mena,
        GeoRegion.subSaharan.objectName: subSaharan,
        GeoRegion.other.objectName: other,
        GeoRegion.undetermined.objectName: undetermined,
      };
}

class ArticleTypeClassification {
  final int industryTrends,
      featureArticle,
      review,
      productLaunchOrUpdate,
      funding,
      partnership,
      acquisition,
      expansion,
      explainer,
      howTo,
      roundup,
      interview,
      profile,
      event,
      thoughtLeadership,
      opinion,
      satire,
      other,
      undetermined;

  int get totalCount =>
      industryTrends +
      featureArticle +
      review +
      productLaunchOrUpdate +
      funding +
      partnership +
      acquisition +
      expansion +
      explainer +
      howTo +
      roundup +
      interview +
      profile +
      event +
      thoughtLeadership +
      opinion +
      satire +
      other +
      undetermined;

  const ArticleTypeClassification({
    required this.industryTrends,
    required this.featureArticle,
    required this.review,
    required this.productLaunchOrUpdate,
    required this.funding,
    required this.partnership,
    required this.acquisition,
    required this.expansion,
    required this.explainer,
    required this.howTo,
    required this.roundup,
    required this.interview,
    required this.profile,
    required this.event,
    required this.thoughtLeadership,
    required this.opinion,
    required this.satire,
    required this.other,
    required this.undetermined,
  });

  const ArticleTypeClassification.empty()
      : industryTrends = 0,
        featureArticle = 0,
        review = 0,
        productLaunchOrUpdate = 0,
        funding = 0,
        partnership = 0,
        acquisition = 0,
        expansion = 0,
        explainer = 0,
        howTo = 0,
        roundup = 0,
        interview = 0,
        profile = 0,
        event = 0,
        thoughtLeadership = 0,
        opinion = 0,
        satire = 0,
        other = 0,
        undetermined = 0;

  factory ArticleTypeClassification.fromJson(Map<String, dynamic> raw) =>
      ArticleTypeClassification(
        industryTrends: raw[ArticleType.industryTrends.objectName] ?? 0,
        featureArticle: raw[ArticleType.featureArticle.objectName] ?? 0,
        review: raw[ArticleType.review.objectName] ?? 0,
        productLaunchOrUpdate:
            raw[ArticleType.productLaunchOrUpdate.objectName] ?? 0,
        funding: raw[ArticleType.funding.objectName] ?? 0,
        partnership: raw[ArticleType.partnership.objectName] ?? 0,
        acquisition: raw[ArticleType.acquisition.objectName] ?? 0,
        expansion: raw[ArticleType.expansion.objectName] ?? 0,
        explainer: raw[ArticleType.explainer.objectName] ?? 0,
        howTo: raw[ArticleType.howTo.objectName] ?? 0,
        roundup: raw[ArticleType.roundup.objectName] ?? 0,
        interview: raw[ArticleType.interview.objectName] ?? 0,
        profile: raw[ArticleType.profile.objectName] ?? 0,
        event: raw[ArticleType.event.objectName] ?? 0,
        thoughtLeadership: raw[ArticleType.thoughtLeadership.objectName] ?? 0,
        opinion: raw[ArticleType.opinion.objectName] ?? 0,
        satire: raw[ArticleType.satire.objectName] ?? 0,
        other: raw[ArticleType.other.objectName] ?? 0,
        undetermined: raw[ArticleType.undetermined.objectName] ?? 0,
      );

  List<ArticleType> topChoices(double percentage) {
    final t = totalCount;

    if (t == 0) return const [ArticleType.undetermined];

    return [
      if (industryTrends >= t * percentage) ArticleType.industryTrends,
      if (featureArticle >= t * percentage) ArticleType.featureArticle,
      if (review >= t * percentage) ArticleType.review,
      if (productLaunchOrUpdate >= t * percentage)
        ArticleType.productLaunchOrUpdate,
      if (funding >= t * percentage) ArticleType.funding,
      if (partnership >= t * percentage) ArticleType.partnership,
      if (acquisition >= t * percentage) ArticleType.acquisition,
      if (expansion >= t * percentage) ArticleType.expansion,
      if (explainer >= t * percentage) ArticleType.explainer,
      if (howTo >= t * percentage) ArticleType.howTo,
      if (roundup >= t * percentage) ArticleType.roundup,
      if (interview >= t * percentage) ArticleType.interview,
      if (profile >= t * percentage) ArticleType.profile,
      if (event >= t * percentage) ArticleType.event,
      if (thoughtLeadership >= t * percentage) ArticleType.thoughtLeadership,
      if (opinion >= t * percentage) ArticleType.opinion,
      if (satire >= t * percentage) ArticleType.satire,
    ];
  }

  double diff(ArticleType type, double range) {
    if (totalCount == 0) return .0;

    int count = 0;

    switch (type) {
      case ArticleType.industryTrends:
        count = industryTrends;
        break;
      case ArticleType.featureArticle:
        count = featureArticle;
        break;
      case ArticleType.review:
        count = review;
        break;
      case ArticleType.productLaunchOrUpdate:
        count = productLaunchOrUpdate;
        break;
      case ArticleType.funding:
        count = funding;
        break;
      case ArticleType.partnership:
        count = partnership;
        break;
      case ArticleType.acquisition:
        count = acquisition;
        break;
      case ArticleType.expansion:
        count = expansion;
        break;
      case ArticleType.explainer:
        count = explainer;
        break;
      case ArticleType.howTo:
        count = howTo;
        break;
      case ArticleType.roundup:
        count = roundup;
        break;
      case ArticleType.interview:
        count = interview;
        break;
      case ArticleType.profile:
        count = profile;
        break;
      case ArticleType.event:
        count = event;
        break;
      case ArticleType.thoughtLeadership:
        count = thoughtLeadership;
        break;
      case ArticleType.opinion:
        count = opinion;
        break;
      case ArticleType.satire:
        count = satire;
        break;
      default:
        count = other + undetermined;
        break;
    }

    return (range - (count / totalCount)).clamp(.0, 1.0);
  }

  ArticleTypeClassification incremented(ArticleType articleType) {
    switch (articleType) {
      case ArticleType.industryTrends:
        return ArticleTypeClassification(
          industryTrends: industryTrends + 1,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.featureArticle:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle + 1,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.review:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review + 1,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.productLaunchOrUpdate:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate + 1,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.funding:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding + 1,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.partnership:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership + 1,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.acquisition:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition + 1,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.expansion:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion + 1,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.explainer:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer + 1,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.howTo:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo + 1,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.roundup:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup + 1,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.interview:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview + 1,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.profile:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile + 1,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.event:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event + 1,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.thoughtLeadership:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership + 1,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.opinion:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion + 1,
          satire: satire,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.satire:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire + 1,
          other: other,
          undetermined: undetermined,
        );
      case ArticleType.other:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other + 1,
          undetermined: undetermined,
        );
      case ArticleType.undetermined:
        return ArticleTypeClassification(
          industryTrends: industryTrends,
          featureArticle: featureArticle,
          review: review,
          productLaunchOrUpdate: productLaunchOrUpdate,
          funding: funding,
          partnership: partnership,
          acquisition: acquisition,
          expansion: expansion,
          explainer: explainer,
          howTo: howTo,
          roundup: roundup,
          interview: interview,
          profile: profile,
          event: event,
          thoughtLeadership: thoughtLeadership,
          opinion: opinion,
          satire: satire,
          other: other,
          undetermined: undetermined + 1,
        );
    }
  }

  Map<String, dynamic> toJson() => {
        ArticleType.industryTrends.objectName: industryTrends,
        ArticleType.featureArticle.objectName: featureArticle,
        ArticleType.review.objectName: review,
        ArticleType.productLaunchOrUpdate.objectName: productLaunchOrUpdate,
        ArticleType.funding.objectName: funding,
        ArticleType.partnership.objectName: partnership,
        ArticleType.acquisition.objectName: acquisition,
        ArticleType.expansion.objectName: expansion,
        ArticleType.explainer.objectName: explainer,
        ArticleType.howTo.objectName: howTo,
        ArticleType.roundup.objectName: roundup,
        ArticleType.interview.objectName: interview,
        ArticleType.profile.objectName: profile,
        ArticleType.event.objectName: event,
        ArticleType.thoughtLeadership.objectName: thoughtLeadership,
        ArticleType.opinion.objectName: opinion,
        ArticleType.satire.objectName: satire,
        ArticleType.other.objectName: other,
        ArticleType.undetermined.objectName: undetermined,
      };
}
