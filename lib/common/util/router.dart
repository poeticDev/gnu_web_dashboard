import 'package:gnu_web_dashboard/common/view/home_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/',
    builder: (context, state) => HomePage(),
    ),
  ],
);