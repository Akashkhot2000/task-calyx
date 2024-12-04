import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/cubit/user_cubit.dart';
import 'package:task/cubit/user_state.dart';
import 'package:task/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:task/screens/bottonNav.dart'; // Import go_router

class userscreen extends StatefulWidget {
  const userscreen({super.key});

  @override
  State<userscreen> createState() => _userscreenState();
}

class _userscreenState extends State<userscreen> {
  late UserCubit userCubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    userCubit = UserCubit();
    userCubit.fetchUserData(); 

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        userCubit.fetchUserData(isLoadMore: true); 
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => userCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('List Of the users'),
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading && userCubit.users.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserLoaded || userCubit.users.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: userCubit.users.length + 1,
                  itemBuilder: (context, index) {
                    if (index < userCubit.users.length) {
                      final user = userCubit.users[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: user.image != null
                                ? NetworkImage(user.image!)
                                : null,
                            child: user.image == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text('${user.firstName} ${user.lastName}'),
                          onTap: () {
                            // context.push('/bottomNav', extra: user,);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNav(
                                  user: user,
                                  userId: (index + 1)
                                      .toString(), 
                                ), // Pass userId to BottomNav
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              );
            }

            if (state is UserError) {
              return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)),
              );
            }

            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}
