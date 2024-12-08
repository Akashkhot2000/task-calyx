import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/cubit/country_cubit.dart';
import 'package:task/cubit/exchage_rate_cubit.dart';
import 'package:task/cubit/user_cubit.dart';
import 'package:task/screens/SeachScreen.dart'; // Import Search Screen
import 'package:task/screens/homescreen.dart'; // Import Home Screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(),
        ),
        BlocProvider<CountryCubit>(
          create: (_) => CountryCubit(),
        ),
        BlocProvider<ExchangeRateCubit>(
          create: (_) => ExchangeRateCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
          ),
          useMaterial3: false,
          textTheme:
              const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
        ),
        // Decide which screen to show first
        home: const SeachScreen(), // Replace with Homescreen() if you prefer
      ),
    );
  }
}
