import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/models/country_model.dart';

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

  Future<void> fetchCountryList(String? countryID) async {
    emit(CountryLoading());
    final body = {
      "clientID": "1",
      "branchID": "2",
      "countryID": countryID ?? "",
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
            countryID: countryID ?? '',
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
