class Country {
  final String popularCountry;
  final String flag;
  final String countryFlag;
  final String countryCode;
  final String isoCode;
  final String countryID;
  final String countryName;
  final String countryCurrency;
  final String preferredFlag;

  Country({
    required this.popularCountry,
    required this.flag,
    required this.countryFlag,
    required this.countryCode,
    required this.isoCode,
    required this.countryID,
    required this.countryName,
    required this.countryCurrency,
    required this.preferredFlag,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    const baseUrl =
        "https://currencyexchangesoftware.eu/pilot/api/country/countrylist/";
    return Country(
      popularCountry: json['popularCountry'] ?? '',
      flag: baseUrl + (json['flag'] ?? ''),
      countryFlag: baseUrl + (json['countryFlag'] ?? ''),
      countryCode: json['countryCode'] ?? '',
      isoCode: json['ISOCode'] ?? '',
      countryID: json['countryID'] ?? '',
      countryName: json['countryName'] ?? '',
      countryCurrency: json['countryCurrency'] ?? '',
      preferredFlag: json['preferredFlag'] ?? '',
    );
  }
}
