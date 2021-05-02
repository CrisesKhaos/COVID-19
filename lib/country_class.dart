class Country {
  final int confirmed;
  final int recovered;
  final int deaths;
  final String name;

  Country(
    this.name,
    this.confirmed,
    this.recovered,
    this.deaths,
  );

  String getActive() {
    final int x = confirmed - recovered;
    return x.toString();
  }
}
