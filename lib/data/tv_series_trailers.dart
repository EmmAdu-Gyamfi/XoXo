class TvSeriesTrailers {
  TvSeriesTrailers({
    required this.iso_639_1,
    required this.iso_3166_1,
    required this.name,
    required this.key,
    required this.publishedAt,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.id,
  });
  late final String iso_639_1;
  late final String iso_3166_1;
  late final String name;
  late final String key;
  late final String publishedAt;
  late final String site;
  late final int size;
  late final String type;
  late final bool official;
  late final String id;

  TvSeriesTrailers.fromJson(Map<String, dynamic> json){
    iso_639_1 = json['iso_639_1'];
    iso_3166_1 = json['iso_3166_1'];
    name = json['name'];
    key = json['key'];
    publishedAt = json['published_at'];
    site = json['site'];
    size = json['size'];
    type = json['type'];
    official = json['official'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['iso_639_1'] = iso_639_1;
    _data['iso_3166_1'] = iso_3166_1;
    _data['name'] = name;
    _data['key'] = key;
    _data['published_at'] = publishedAt;
    _data['site'] = site;
    _data['size'] = size;
    _data['type'] = type;
    _data['official'] = official;
    _data['id'] = id;
    return _data;
  }
}