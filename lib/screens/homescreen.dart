import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/common_component.dart';
import 'package:task/comom_wallet.dart';
import 'package:task/cubit/country_cubit.dart';
import 'package:task/cubit/exchage_rate_cubit.dart';
import 'package:task/models/country_model.dart';
import 'package:task/models/user_model.dart';
import 'package:task/screens/SeachScreen.dart';

class Homescreen extends StatefulWidget {
  final Users user;
  final String userId;

  const Homescreen({super.key, required this.user, required this.userId});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Country? selectedCountry;
  void initState() {
    super.initState();
    context.read<CountryCubit>().fetchCountryList(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: widget.user.image != null
                    ? NetworkImage(widget.user.image!)
                    : null,
                child:
                    widget.user.image == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hi,',
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  Text('${widget.user.firstName} ${widget.user.lastName}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                  const Text('13 Nov 2024',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ],
              ),
              const Spacer(),
              const Text('HELP?',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(width: 2, height: 30, color: Colors.black),
              ),
              const Icon(Icons.notification_add_rounded, color: Colors.black),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => CountryCubit()..fetchCountryList(widget.userId),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocListener<CountryCubit, CountryState>(
              listener: (context, state) {
                if (state is CountryError) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text(state.message)),
                  // );
                }
              },
              child: BlocBuilder<CountryCubit, CountryState>(
                builder: (context, state) {
                  if (state is CountryLoading) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is CountryLoaded) {
                    return BlocProvider(
                      create: (_) => ExchangeRateCubit()
                        ..fetchExchangeRates(state.countryID),
                      child: BlocBuilder<ExchangeRateCubit, ExchangeRateState>(
                          builder: (BuildContext context,
                              ExchangeRateState exchangeRateState) {
                        if (exchangeRateState is ExchangeRateLoading) {
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        } else if (exchangeRateState is ExchangeRateLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Sending To',
                                  style: TextStyle(color: Colors.black),
                                ),
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
                                                preferredFlag: ''),
                                      ),
                                    ),
                                  );
                                  if (selected is Country) {
                                    setState(() {
                                      selectedCountry = selected;
                                    });
                                  }
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundImage: exchangeRateState
                                                  .rates.isNotEmpty
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
                                                : state.countries.isNotEmpty
                                                    ? state.countries
                                                        .map((country) =>
                                                            country.countryName)
                                                        .join(', ')
                                                    : 'No Currencies',
                                            style:
                                                const TextStyle(fontSize: 15),
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
                                child: Text(
                                  'You send',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        state.countries.isNotEmpty
                                            ? state.countries
                                                .map((country) =>
                                                    country.countryID)
                                                .join(', ')
                                            : 'No Contry ID',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          selectedCountry != null
                                              ? selectedCountry!.countryCurrency
                                              : state.countries.isNotEmpty
                                                  ? state.countries
                                                      .map((country) => country
                                                          .countryCurrency)
                                                      .join(', ')
                                                  : 'No Currencies',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      Column(
                                        children:
                                            state.countries.map((country) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 15,
                                                  backgroundImage:
                                                      country.flag.isNotEmpty
                                                          ? NetworkImage(
                                                              country.flag)
                                                          : null,
                                                  child: country.flag.isEmpty
                                                      ? const Icon(Icons.flag,
                                                          size: 15)
                                                      : null,
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Recipient Gets',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          exchangeRateState
                                              .rates[0].foreignCurrencyMaxAmount
                                              .toString(),
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          exchangeRateState
                                              .rates[0].currencyCode
                                              .toString(),
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
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
                              SizedBox(
                                height: 10,
                              ),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Transfer Fees',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  "${exchangeRateState.rates.isNotEmpty ? exchangeRateState.rates[0].transferFeesGBP.toString() : ""}  ${exchangeRateState.rates.isNotEmpty ? state.countries[0].countryCurrency : ""}",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Exchange Rate',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  ' ${exchangeRateState.rates.isNotEmpty ? exchangeRateState.rates[0].foreignCurrencyMaxAmount : ""} ${exchangeRateState.rates.isNotEmpty ? exchangeRateState.rates[0].currencyCode : ""}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total Amount To Pay',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const Spacer(),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  '3.00',
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                              Text(
                                                "${exchangeRateState.rates.isNotEmpty ? state.countries[0].countryCurrency : ""}",
                                                style: TextStyle(fontSize: 15),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
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
                      }),
                    );
                  } else if (state is CountryError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
