import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/common_component.dart';
import 'package:task/cubit/country_cubit.dart';
import 'package:task/cubit/exchage_rate_cubit.dart';

class Homescreen extends StatefulWidget {
  final Country country;

  const Homescreen({super.key, required this.country});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late ExchangeRateCubit _exchangeRateCubit;
  double? inputAmount;
  double? convertedAmount;

  @override
  void initState() {
    super.initState();
    _exchangeRateCubit = ExchangeRateCubit();
    _exchangeRateCubit.fetchExchangeRates(
        widget.country.countryID, widget.country.countryCurrency);
  }

  void calculateCurrency(String value, double rate) {
    setState(() {
      inputAmount = double.tryParse(value);
      convertedAmount = inputAmount != null ? inputAmount! * rate : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: BlocProvider(
              create: (_) => _exchangeRateCubit,
              child: BlocBuilder<ExchangeRateCubit, ExchangeRateState>(
                builder: (context, state) {
                  if (state is ExchangeRateLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ExchangeRateLoaded) {
                    final exchangeRate = state.rate;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Sending To',
                              style: TextStyle(color: Colors.black)),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CircleAvatar(
                                      radius: 15,
                                      child: Icon(Icons.flag, size: 15)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.country.countryName,
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
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      hintText: "Enter Amount",
                                    ),
                                    onChanged: (value) {
                                      calculateCurrency(
                                          value, exchangeRate.rate);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.country.countryName,
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
                                    exchangeRate.rate.toString(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${exchangeRate.currencyCode}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const CircleAvatar(
                                      radius: 15,
                                      child: Icon(Icons.flag, size: 15)),
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
                                            "${exchangeRate.transferFeesGBP} GBP",
                                            style:
                                                const TextStyle(fontSize: 15),
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
                                          Spacer(),
                                          Text(
                                            convertedAmount != null
                                                ? convertedAmount!
                                                    .toStringAsFixed(2)
                                                : "0.00",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            exchangeRate.currencyCode,
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
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Amount To Pay',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            '3.00',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        Text(
                                          'GBP',
                                          style: TextStyle(fontSize: 15),
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
                  } else if (state is ExchangeRateError) {
                    return Text('Error: ${state.message}');
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
