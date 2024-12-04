import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/cubit/country_cubit.dart'; // Import the CountryCubit
import 'package:task/models/country_model.dart'; // Import the Country model

class SeachScreen extends StatefulWidget {
  final Country country;
  const SeachScreen({super.key, required this.country});

  @override
  State<SeachScreen> createState() => _SeachScreenState();
}

class _SeachScreenState extends State<SeachScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Country> _filteredCountries = [];
  List<Country> _allCountries = [];

  @override
  void initState() {
    super.initState();
    context.read<CountryCubit>().fetchCountryList("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (query) {
            _filterCountries(query);
          },
          decoration: InputDecoration(
            hintText: 'Search Country',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<CountryCubit, CountryState>(
        builder: (context, state) {
          if (state is CountryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CountryLoaded) {
            // Cache the country list when it's loaded
            if (_allCountries.isEmpty) {
              _allCountries = state.countries;
              _filteredCountries = _allCountries;
            }

            return ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: ListTile(
                      title: Text(country.countryName),
                      subtitle: Text(country.countryCurrency),
                      trailing: Text(country.countryCode),
                      onTap: () {
                        // Return selected country back to the previous screen
                        Navigator.pop(context, country);
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is CountryError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('No data available.'));
        },
      ),
    );
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = _allCountries
          .where((country) =>
              country.countryName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
