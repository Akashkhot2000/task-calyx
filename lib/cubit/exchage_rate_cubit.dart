import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

// States
abstract class ExchangeRateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExchangeRateInitial extends ExchangeRateState {}

class ExchangeRateLoading extends ExchangeRateState {}

class ExchangeRateLoaded extends ExchangeRateState {
  final ExchangeRate rate;

  ExchangeRateLoaded(this.rate);

  @override
  List<Object?> get props => [rate];
}

class ExchangeRateError extends ExchangeRateState {
  final String message;

  ExchangeRateError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class ExchangeRateCubit extends Cubit<ExchangeRateState> {
  final Dio _dio = Dio();

  ExchangeRateCubit() : super(ExchangeRateInitial());

  Future<void> fetchExchangeRates(String countryID, String currencyCode) async {
    emit(ExchangeRateLoading());
    const url =
        'https://currencyexchangesoftware.eu/pilot/api/checkrateslistcountry/checkrateslistcountry';
    final body = {
      "clientID": "1",
      "countryID": countryID,
      "paymentTypeID": "1",
      "paymentDepositTypeID": "1",
      "deliveryTypeID": "3",
      "currencyCode": currencyCode,
      "branchID": "2",
      "BaseCurrencyID": "22"
    };
    log("Request Body: $body");
    try {
      final response = await _dio.post(url, data: body);

      if (response.data['response'] == true && response.data['data'] is List) {
        final List<dynamic> data = response.data['data'];
        if (data.isNotEmpty) {
          final firstRate = ExchangeRate.fromJson(data.first);
          emit(ExchangeRateLoaded(firstRate));
        } else {
          emit(ExchangeRateError('No exchange rate data found'));
        }
      } else {
        final errorMessage =
            response.data['data'] ?? 'Unexpected response structure';
        emit(ExchangeRateError('Failed to fetch rates: $errorMessage'));
      }
    } catch (e) {
      emit(ExchangeRateError('Failed to fetch rates: ${e.toString()}'));
    }
  }
}

// Model
class ExchangeRate {
  final String countryName;
  final String currencyCode;
  final String countryFlag;
  final double minAmount;
  final double maxAmount;
  final double foreignCurrencyMinAmount;
  final double foreignCurrencyMaxAmount;
  final double transferFeesGBP;
  final double rate;

  ExchangeRate({
    required this.countryName,
    required this.currencyCode,
    required this.countryFlag,
    required this.minAmount,
    required this.maxAmount,
    required this.foreignCurrencyMinAmount,
    required this.foreignCurrencyMaxAmount,
    required this.transferFeesGBP,
    required this.rate,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      countryName: json['countryName'] ?? 'Unknown',
      currencyCode: json['currencyCode'] ?? 'Unknown',
      countryFlag: json['countryFlag'] ?? '',
      minAmount: json['minAmount']?.toDouble() ?? 0.0,
      maxAmount: json['maxAmount']?.toDouble() ?? 0.0,
      foreignCurrencyMinAmount:
          json['foreignCurrencyMinAmount']?.toDouble() ?? 0.0,
      foreignCurrencyMaxAmount:
          json['foreignCurrencyMaxAmount']?.toDouble() ?? 0.0,
      transferFeesGBP: json['transferFeesGBP']?.toDouble() ?? 0.0,
      rate: json['rate']?.toDouble() ?? 0.0,
    );
  }

  String get fullFlagUrl {
    return countryFlag.isNotEmpty
        ? 'https://currencyexchangesoftware.eu/pilot/api/country/countrylist/$countryFlag'
        : 'https://via.placeholder.com/15';
  }
}
