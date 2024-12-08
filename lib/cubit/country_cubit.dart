import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CountryState {}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountryLoaded extends CountryState {
  final List<Country> countries;
  final String branchID;
  final String countryID;

  CountryLoaded({
    required this.countries,
    required this.branchID,
    required this.countryID,
  });
}

class CountryError extends CountryState {
  final String message;

  CountryError(this.message);
}

class CountryCubit extends Cubit<CountryState> {
  final Dio _dio = Dio();

  CountryCubit() : super(CountryInitial());

  // Define the API URL as a constant
  static const String _apiUrl =
      'https://currencyexchangesoftware.eu/pilot/api/country/countrylist';

  Future<void> fetchCountryList() async {
    emit(CountryLoading());
    final body = {
      "clientID": "1",
      "branchID": "2",
      "countryID": "",
    };

    try {
      final response = await _dio.post(_apiUrl, data: body);

      if (response.data['response'] == true) {
        final List<dynamic> data = response.data['data'];
        if (data.isEmpty) {
          emit(CountryError('No countries available.'));
        } else {
          final countries = data.map((json) => Country.fromJson(json)).toList();
          emit(CountryLoaded(
            countries: countries,
            branchID: "2",
            countryID: '',
          ));
        }
      } else {
        final errorMessage =
            response.data['response'] ?? 'Unknown server error';
        emit(CountryError('Failed to fetch countries: $errorMessage'));
      }
    } catch (e) {
      emit(CountryError('Error fetching countries: $e'));
    }
  }
}

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
