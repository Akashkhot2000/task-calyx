// import 'package:go_router/go_router.dart';
// import 'package:task/models/user_model.dart';
// import 'package:task/screens/bottonNav.dart';
// import 'package:task/screens/userScreen.dart';
// import 'package:task/screens/homescreen.dart'; // Import Homescreen

// class AppRouter {
//   static final GoRouter router = GoRouter(
//     routes: [
//       GoRoute(
//         path: '/homescreen',
//         builder: (context, state) {
//           final Users user = state.extra as Users; // Access extra data
//           final userId = state.extra as int;
//           return Homescreen(
//             user: user,
//             user_id: userId,
//           ); // Pass the user to Homescreen
//         },
//       ),
//       GoRoute(
//         path: '/bottomNav',
//         builder: (context, state) {
//           final Users user = state.extra as Users;
//           final userId = state.extra as int;
//           return BottomNav(
//             user: user,
//             user_id: userId,
//           );
//         },
//       ),
//       GoRoute(
//         path: '/',
//         builder: (context, state) => const userscreen(),
//       ),
//     ],
//   );
// }
