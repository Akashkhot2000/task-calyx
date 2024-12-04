import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task/cubit/user_state.dart';
import 'package:task/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final List<Users> _users = [];
  bool _isFetching = false;
  int _currentPage = 0;
  final int _limit = 20;

  List<Users> get users => List.unmodifiable(_users);

  Future<void> fetchUserData({bool isLoadMore = false}) async {
    if (_isFetching) return;

    _isFetching = true;

    if (!isLoadMore) {
      emit(UserLoading());
    }

    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        emit(UserError('No internet connection'));
        _isFetching = false;
        return;
      }

      final Uri uri = Uri.parse('https://dummyjson.com/users').replace(
          queryParameters: {
            'limit': '$_limit',
            'skip': '${_currentPage * _limit}'
          });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newUsers = UserModels.fromJson(jsonData).users;

        if (newUsers != null && newUsers.isNotEmpty) {
          _users.addAll(newUsers);
          _currentPage++;
        }
        emit(UserLoaded(UserModels(users: _users)));
      } else {
        emit(UserError('Failed to load user data: ${response.reasonPhrase}'));
      }
    } on FormatException catch (e) {
      log('Error parsing response JSON: $e');
      emit(UserError('Failed to parse user data'));
    } on SocketException catch (e) {
      log('Network error: $e');
      emit(UserError('Network error'));
    } catch (e) {
      log('Unexpected error: $e');
      emit(UserError('Unexpected error occurred'));
    } finally {
      _isFetching = false;
    }
  }
}
