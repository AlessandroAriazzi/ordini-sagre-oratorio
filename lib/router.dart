import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/serate_list_screen.dart';
import 'screens/serata_detail_screen.dart';
import 'screens/menu_editor_screen.dart';
import 'screens/ordine_screen.dart';
import 'screens/resoconto_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/main.layout.dart';


final router = GoRouter(
  initialLocation: '/',
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
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/serate',
          builder: (context, state) => const SerateListScreen(),
        ),
        GoRoute(
          path: '/serata/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return SerataDetailScreen(serataId: id);
          },
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
          path: '/menu/new',
          builder: (context, state) => const MenuEditorScreen(),
        ),
        GoRoute(
          path: '/menu/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return MenuEditorScreen(menuId: id);
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
