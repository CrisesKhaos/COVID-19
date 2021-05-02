class Country {
  final int confirmed;
  final int recovered;
  final int deaths;
  final int active;
  final String name;

  Country(
    this.name,
    this.confirmed,
    this.active,
    this.recovered,
    this.deaths,
  );
}
