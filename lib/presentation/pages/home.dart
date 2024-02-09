import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styles.dart';
import 'my_account/my_account.dart';
import 'my_projects_page.dart';

class HomePage extends ConsumerStatefulWidget {
  static String routName = 'home';

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _screensList = const [
    MyProjectsPage(),
    MyAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screensList),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          if (index != _selectedIndex) {
            setState(() => _selectedIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_rounded),
            label: 'Мои проекты',
          ),
          BottomNavigationBarItem(
            icon: Icon(MyProjectIcons.account),
            label: 'Мои аккаунт',
          ),
        ],
        backgroundColor: kScaffoldBackground,
      ),
    );
  }
}
