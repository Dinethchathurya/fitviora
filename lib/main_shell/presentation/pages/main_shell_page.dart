import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/meal_plan/presentation/pages/meal_plan_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/progress/presentation/pages/progress_page.dart';
import '../../../features/reports/presentation/pages/reports_page.dart';
import '../viewmodels/main_nav_view_model.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainNavViewModel>();

    const pages = [
      HomePage(),
      ProgressPage(),
      ReportsPage(),
      MealPlanPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: vm.currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: vm.currentIndex,
        onDestinationSelected: vm.changeIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Meal Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
