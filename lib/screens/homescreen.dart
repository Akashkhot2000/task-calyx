import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/common_component.dart';
import 'package:task/cubit/exchage_rate_cubit.dart';
import 'package:task/models/country_model.dart';
import 'package:task/screens/SeachScreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Country? selectedCountry;
  double? inputAmount;
  double? convertedAmount;

  void calculateCurrency(double rate) {
    if (inputAmount != null) {
      setState(() {
        convertedAmount = inputAmount! * rate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocProvider(
            create: (_) => ExchangeRateCubit()
              ..fetchExchangeRates(selectedCountry?.countryID ?? '6',
                  selectedCountry?.countryCurrency ?? "NGN"),
            child: BlocBuilder<ExchangeRateCubit, ExchangeRateState>(
              builder:
                  (BuildContext context, ExchangeRateState exchangeRateState) {
                if (exchangeRateState is ExchangeRateLoading) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (exchangeRateState is ExchangeRateLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Sending To',
                            style: TextStyle(color: Colors.black)),
                      ),
                      InkWell(
                        onTap: () async {
                          final selected = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeachScreen(
                                country: selectedCountry ??
                                    Country(
                                      countryName: 'Default Country',
                                      flag: 'default_url',
                                      popularCountry: '',
                                      countryFlag: '',
                                      countryCode: '',
                                      isoCode: '',
                                      countryID: '',
                                      countryCurrency: '',
                                      preferredFlag: '',
                                    ),
                              ),
                            ),
                          );
                          if (selected is Country) {
                            setState(() {
                              selectedCountry = selected;
                              // log(selectedCountry!.countryID);
                            });
                          }
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage:
                                      exchangeRateState.rates.isNotEmpty
                                          ? NetworkImage(exchangeRateState
                                              .rates[0].fullFlagUrl)
                                          : null,
                                  child: exchangeRateState.rates.isEmpty
                                      ? const Icon(Icons.flag, size: 15)
                                      : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    selectedCountry != null
                                        ? selectedCountry!.countryName
                                        : 'Select the Country',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.search_rounded)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('You send',
                            style: TextStyle(color: Colors.black)),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 140,
                                height: 50,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: "Enter Amount",
                                  ),
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        inputAmount = 0.0;
                                        convertedAmount = 0.0;
                                      });
                                    } else {
                                      inputAmount = double.tryParse(value);
                                      if (selectedCountry != null &&
                                          exchangeRateState.rates.isNotEmpty) {
                                        final rate =
                                            exchangeRateState.rates[0].rate;
                                        calculateCurrency(rate);
                                      }
                                    }
                                  },
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  selectedCountry != null
                                      ? selectedCountry!.countryCurrency
                                      : 'No Country',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Recipient Gets',
                            style: TextStyle(color: Colors.black)),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  '$convertedAmount',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  exchangeRateState.rates[0].currencyCode,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              CircleAvatar(
                                radius: 15,
                                backgroundImage: exchangeRateState
                                        .rates.isNotEmpty
                                    ? NetworkImage(
                                        exchangeRateState.rates[0].fullFlagUrl)
                                    : null,
                                child: exchangeRateState.rates.isEmpty
                                    ? const Icon(Icons.flag, size: 15)
                                    : null,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Transfer Fees',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "${exchangeRateState.rates.isNotEmpty ? exchangeRateState.rates[0].transferFeesGBP.toString() : ""}  ${exchangeRateState.rates.isNotEmpty ? exchangeRateState.rates[0].currencyCode : ""}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Exchange Rate',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          ' $convertedAmount ${exchangeRateState.rates.isNotEmpty ? exchangeRateState.rates[0].currencyCode : ""}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total Amount To Pay',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          '3.00',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      Text(
                                        "${exchangeRateState.rates.isNotEmpty ? exchangeRateState.rates[0].currencyCode : ""}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        onPressed: () {},
                        text: 'Continue to Login',
                        textColor: Colors.white,
                        height: 30,
                        fontSize: 16,
                        width: double.infinity,
                      ),
                    ],
                  );
                } else if (exchangeRateState is ExchangeRateError) {
                  return Center(child: Text(exchangeRateState.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
