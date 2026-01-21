import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'needs_assessment_screen.dart';
import 'budget_planning_screen.dart';
import 'car_comparison_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const NeedsAssessmentScreen(),
    const BudgetPlanningScreen(),
    const CarComparisonScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // 取得當前使用者名稱
    final username = context.select<AuthProvider, String?>((auth) => auth.username);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${username ?? 'User'}'), // 顯示使用者名稱
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '登出',
            onPressed: () {
              // 執行登出並確認
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('登出'),
                  content: const Text('確定要登出嗎？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 關閉對話框
                        Provider.of<AuthProvider>(context, listen: false).logout();
                      },
                      child: const Text('確定'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: '需求評估',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: '預算規劃',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare),
            label: '車輛比較',
          ),
        ],
      ),
    );
  }
}
