import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/cubit/country_cubit.dart';
import 'package:task/models/country_model.dart';

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
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<CountryCubit, CountryState>(
        builder: (context, state) {
          if (state is CountryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CountryLoaded) {
            if (_allCountries.isEmpty) {
              _allCountries = state.countries;
              _filteredCountries = _allCountries;
            }

            return ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: Card(
                    child: ListTile(
                      title: Text(country.countryName),
                      subtitle: Text(country.countryCurrency),
                      trailing: Text(country.countryCode),
                      onTap: () {
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
