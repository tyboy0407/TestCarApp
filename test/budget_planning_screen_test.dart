import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:testcar/providers/evaluation_provider.dart';
import 'package:testcar/providers/vehicle_provider.dart';
import 'package:testcar/screens/budget_planning_screen.dart';

void main() {
  testWidgets('BudgetPlanningScreen has two tabs and SavingGoalTab works with Loan Logic', (WidgetTester tester) async {
    // Create providers
    final evaluationProvider = EvaluationProvider();
    final vehicleProvider = VehicleProvider(); 

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: evaluationProvider),
          ChangeNotifierProvider.value(value: vehicleProvider),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: BudgetPlanningScreen(),
          ),
        ),
      ),
    );

    // Navigate to Saving Goal Tab
    await tester.tap(find.text('存錢計畫'));
    await tester.pumpAndSettle();

    // Verify UI Elements
    expect(find.text('1. 選擇車型與確認價格'), findsOneWidget);
    expect(find.text('2. 付款方式'), findsOneWidget);
    expect(find.text('3. 您的存錢能力'), findsOneWidget);
    
    // Test Interaction: Search Vehicle
    final searchFieldFinder = find.widgetWithText(TextField, '選擇車型 (選填)');
    await tester.enterText(searchFieldFinder, 'Corolla');
    await tester.pumpAndSettle();

    // Select option
    final optionFinder = find.textContaining('Corolla Altis 1.8 汽油尊爵');
    expect(optionFinder, findsOneWidget);
    await tester.tap(optionFinder);
    await tester.pumpAndSettle();

    // Verify Price Field is populated
    final priceFieldFinder = find.widgetWithText(TextFormField, '車輛目標成交價 (NT\$)');
    expect(find.descendant(of: priceFieldFinder, matching: find.text('885000')), findsOneWidget);

    // Enter Monthly Savings
    final savingsFieldFinder = find.widgetWithText(TextFormField, '預計每月存入金額 (NT\$)');
    await tester.enterText(savingsFieldFinder, '20000');
    await tester.pumpAndSettle();

    // Verify Cash Result (Default)
    // 885000 / 20000 = 44.25 -> 45 months = 3 years 9 months
    expect(find.text('3 年 9 個月'), findsOneWidget);
    expect(find.textContaining('存到 Corolla Altis 1.8 汽油尊爵 全額車價所需時間'), findsOneWidget);

    // Switch to Loan
    await tester.tap(find.text('貸款購車'));
    await tester.pumpAndSettle();

    // Verify Loan Fields appear
    expect(find.text('貸款條件設定'), findsOneWidget);
    
    // Check default down payment (20% of 885,000 = 177,000)
    final downPaymentFinder = find.widgetWithText(TextFormField, '頭期款金額 (NT\$)');
    expect(find.descendant(of: downPaymentFinder, matching: find.text('177000')), findsOneWidget);

    // Verify Loan Result (Down Payment Target)
    // 177,000 / 20,000 = 8.85 -> 9 months
    expect(find.text('9 個月'), findsOneWidget);
    expect(find.textContaining('存到 Corolla Altis 1.8 汽油尊爵 頭期款所需時間'), findsOneWidget);

    // Verify Total Cost Calculation Info
    expect(find.text('貸款總支出觀點'), findsOneWidget);
  });
}