import 'package:go_router/go_router.dart';
import 'screens/serate_list_screen.dart';

import 'screens/alimenti_screen.dart';
import 'screens/ordine_screen.dart';
import 'screens/ordini_list_screen.dart';
import 'screens/resoconto_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/main.layout.dart';


final router = GoRouter(
  initialLocation: '/serate',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(
          currentPath: state.uri.path,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/serate',
          builder: (context, state) => const SerateListScreen(),
        ),
       
        GoRoute(
          path: '/ordine/:serataId/:ordineId',
          builder: (context, state) {
            final serataId = int.parse(state.pathParameters['serataId']!);
            final ordineId = int.parse(state.pathParameters['ordineId']!);
            return OrdineScreen(serataId: serataId, ordineId: ordineId);
          },
        ),
        GoRoute(
          path: '/resoconto/:serataId',
          builder: (context, state) {
            final serataId = int.parse(state.pathParameters['serataId']!);
            return ResocontoScreen(serataId: serataId);
          },
        ),
        GoRoute(
          path: '/ordini',
          builder: (context, state) => const OrdiniListScreen(),
        ),
        GoRoute(
          path: '/alimenti',
          builder: (context, state) => const AlimentiScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
