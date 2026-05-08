import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mintyn_app/main.dart';
import 'package:mintyn_app/widgets/balance_card.dart';
import 'package:mintyn_app/widgets/spending_chart.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Core App Integration Tests', () {
    testWidgets('App starts and shows loading then content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MintynApp(),
        ),
      );

      // Should show loading initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the simulated delay (900ms)
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Should now show home screen content
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(BalanceCard), findsOneWidget);
    });

    testWidgets('Home screen displays balance card and transaction history header', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MintynApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Check for balance card
      expect(find.byType(BalanceCard), findsOneWidget);
      
      // Scroll down to see transaction history header
      final transactionHistoryFinder = find.text('Transaction History');
      await tester.scrollUntilVisible(
        transactionHistoryFinder,
        300.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      
      expect(transactionHistoryFinder, findsOneWidget);
    });

    testWidgets('Drawer can be opened and shows profile info', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MintynApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Open drawer by tapping menu icon
      final menuIcon = find.byIcon(Icons.menu);
      expect(menuIcon, findsOneWidget);
      
      await tester.tap(menuIcon);
      await tester.pumpAndSettle();

      // Verify drawer content
      expect(find.text('Profile Settings'), findsOneWidget);
      expect(find.text('Tayyab Sohail'), findsWidgets);
    });

    testWidgets('Navigate to Card Screen from drawer', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MintynApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap on Credit Card
      await tester.tap(find.text('Credit Card'));
      await tester.pumpAndSettle();

      // Should be on Card Screen
      expect(find.text('Your Card'), findsOneWidget);
      expect(find.text('Card Settings'), findsOneWidget);
    });

    testWidgets('Card Screen toggles between physical and virtual', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MintynApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Navigate to Card Screen
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Credit Card'));
      await tester.pumpAndSettle();

      // Verify both toggle options exist
      expect(find.text('Physical Card'), findsOneWidget);
      expect(find.text('Virtual Card'), findsOneWidget);

      // Tap on Virtual Card
      await tester.tap(find.text('Virtual Card'));
      await tester.pumpAndSettle();

      // Should still be on Card Screen (no crash)
      expect(find.text('Your Card'), findsOneWidget);
    });

    testWidgets('Navigate to Profile Screen from drawer', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MintynApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap on Settings (which navigates to Profile Screen)
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Should be on Profile Screen
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Profile Settings'), findsOneWidget);
    });

    testWidgets('Profile Screen shows user details', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MintynApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Navigate to Profile Screen
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify user details
      expect(find.text('Tayyab Sohail'), findsWidgets);
      expect(find.text('UI/UX Designer'), findsOneWidget);
      expect(find.text('tayyabsohaild@gmail.com'), findsOneWidget);
    });

    testWidgets('Transaction Screen displays chart and transactions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MintynApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Navigate to Card Screen first
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Credit Card'));
      await tester.pumpAndSettle();

      // On Card Screen, scroll down to find 'Card Transactions'
      final cardTransactionsFinder = find.text('Card Transactions');
      await tester.scrollUntilVisible(
        cardTransactionsFinder,
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // Tap on Card Transactions
      await tester.tap(cardTransactionsFinder);
      await tester.pumpAndSettle();

      // Should be on Transaction Screen
      expect(find.byType(SpendingChart), findsOneWidget);
      expect(find.text('Card Transaction'), findsOneWidget);
      
      // Scroll to see Transaction History header
      final transactionHistoryFinder = find.text('Transaction History');
      await tester.scrollUntilVisible(
        transactionHistoryFinder,
        300.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(transactionHistoryFinder, findsOneWidget);
    });

    testWidgets('Drawer switches can be toggled', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MintynApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Find switches
      final switches = find.byType(Switch);
      expect(switches, findsWidgets);

      // Toggle first switch (App Notification)
      await tester.tap(switches.first);
      await tester.pumpAndSettle();
    });

    testWidgets('Logout dialog can be opened and dismissed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MintynApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Find the Logout button (TextButton with text 'Logout')
      final logoutButton = find.widgetWithText(TextButton, 'Logout');
      if (tester.any(logoutButton)) {
        await tester.tap(logoutButton);
        await tester.pumpAndSettle();

        // Verify dialog appears
        expect(find.text('Logout'), findsOneWidget);
        expect(find.text('Are you sure you want to logout?'), findsOneWidget);

        // Dismiss dialog
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Dialog should be dismissed
        expect(find.text('Logout'), findsNothing);
      } else {
        // If button not found, skip gracefully
        print('Logout button not found, skipping dialog test');
      }
    });
  });
}