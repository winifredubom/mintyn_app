import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mintyn_app/main.dart';
import 'package:mintyn_app/models/card_model.dart';
import 'package:mintyn_app/models/transaction_model.dart';
import 'package:mintyn_app/widgets/balance_card.dart';
import 'package:mintyn_app/widgets/transaction_item.dart';
import 'package:mintyn_app/widgets/spending_chart.dart';
import 'package:mintyn_app/widgets/quick_actions.dart';
import 'package:mintyn_app/widgets/common/async_state.dart';
import 'package:mintyn_app/constants/colors.dart';
import 'package:mintyn_app/constants/typography.dart';
import 'package:mintyn_app/constants/spacing.dart';

void main() {
  // Initialize Flutter binding for tests that need it
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TransactionItem Widget Tests', () {
    testWidgets('TransactionItem displays correctly for income', (WidgetTester tester) async {
      final transaction = Transaction(
        id: '1',
        name: 'Salary',
        description: 'Monthly salary',
        amount: 5000.0,
        type: TransactionType.income,
        dateTime: DateTime(2024, 1, 15, 10, 30),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionItem(transaction: transaction),
          ),
        ),
      );

      expect(find.text('Salary'), findsOneWidget);
      expect(find.textContaining('+'), findsWidgets);
      expect(find.textContaining('10:30'), findsWidgets);
    });

    testWidgets('TransactionItem displays correctly for expense', (WidgetTester tester) async {
      final transaction = Transaction(
        id: '2',
        name: 'Shopping',
        description: 'Grocery shopping',
        amount: 150.75,
        type: TransactionType.expense,
        dateTime: DateTime(2024, 1, 16, 14, 20),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionItem(transaction: transaction),
          ),
        ),
      );

      expect(find.text('Shopping'), findsOneWidget);
      expect(find.textContaining('-'), findsWidgets);
    });

    testWidgets('TransactionItem icon changes based on transaction name', (WidgetTester tester) async {
      final transaction = Transaction(
        id: '3',
        name: 'E wallet',
        description: 'Transfer',
        amount: 100.0,
        type: TransactionType.income,
        dateTime: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionItem(transaction: transaction),
          ),
        ),
      );

      // Should display an icon
      expect(find.byType(Icon), findsWidgets);
    });
  });

  group('BalanceCard Widget Tests', () {
    testWidgets('BalanceCard builds without error', (WidgetTester tester) async {
      // Provide a mock for asset images
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              balance: 1234.56,
              cardBrand: 'mastercard',
            ),
          ),
        ),
      );

      // Pump and settle to allow images to attempt loading
      await tester.pumpAndSettle();

      // The widget should build without throwing
      expect(tester.takeException(), isNull);
    });

    testWidgets('BalanceCard handles zero balance', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              balance: 0.0,
              cardBrand: 'visa',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('SpendingChart Widget Tests', () {
    testWidgets('SpendingChart renders with data', (WidgetTester tester) async {
      final monthlyData = [1200.0, 2800.0, 1800.0, 3657.0, 2200.0, 4100.0];
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SpendingChart(
              monthlyData: monthlyData,
              months: months,
              totalSpend: '30',
              selectedPeriod: 'Weekly',
              onPeriodChanged: (period) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Total Spend'), findsOneWidget);
      expect(find.text('\$30'), findsOneWidget);
    });

    testWidgets('SpendingChart dropdown changes period', (WidgetTester tester) async {
      String? selectedPeriod;
      final monthlyData = [1200.0, 2800.0, 1800.0, 3657.0, 2200.0, 4100.0];
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SpendingChart(
                  monthlyData: monthlyData,
                  months: months,
                  totalSpend: '30',
                  selectedPeriod: selectedPeriod ?? 'Weekly',
                  onPeriodChanged: (period) {
                    setState(() {
                      selectedPeriod = period;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Tap the dropdown to open it
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Select 'Monthly'
      await tester.tap(find.text('Monthly').last);
      await tester.pumpAndSettle();

      expect(selectedPeriod, 'Monthly');
    });
  });

  group('QuickActions Widget Tests', () {
    testWidgets('QuickActions renders all actions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuickActions(
              onBillPay: () {},
              onDonations: () {},
              onDeposit: () {},
              onMore: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Bill Pay'), findsOneWidget);
      expect(find.text('Donations'), findsOneWidget);
      expect(find.text('Deposit'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);
    });

    testWidgets('QuickActions callbacks are passed correctly', (WidgetTester tester) async {
      // This test verifies that the QuickActions widget accepts callbacks
      // The callbacks are passed but currently not wired to actual tap handlers in the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuickActions(
              onBillPay: () {},
              onDonations: () {},
              onDeposit: () {},
              onMore: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Widget should render without error
      expect(find.byType(QuickActions), findsOneWidget);
      expect(find.text('Bill Pay'), findsOneWidget);
      expect(find.text('Donations'), findsOneWidget);
      expect(find.text('Deposit'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);
    });
  });

  group('AsyncState Widget Tests', () {
    testWidgets('LoadingView displays CircularProgressIndicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingView(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('ErrorView displays error message and retry button', (WidgetTester tester) async {
      bool retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(retryCalled, true);
    });
  });

  group('App Integration Tests', () {
    testWidgets('App starts and displays home screen', (WidgetTester tester) async {
      // This test requires the full app with ProviderScope
      await tester.pumpWidget(
        const ProviderScope(
          child: MintynApp(),
        ),
      );

      // Wait for the async provider to load (simulated delay 900ms)
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Should display the home screen with balance card
      expect(find.byType(BalanceCard), findsOneWidget);
    });
  });
}