import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mintyn_app/providers/account_provider.dart';
import 'package:mintyn_app/models/account_model.dart';
import 'package:mintyn_app/models/card_model.dart';
import 'package:mintyn_app/models/transaction_model.dart';
import 'package:mintyn_app/models/user_model.dart';

void main() {
  group('AccountNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('AccountNotifier initial state is loading', () async {
      final notifier = container.read(accountProvider.notifier);
      expect(notifier.state, isA<AsyncLoading>());
    });

    test('AccountNotifier fetches account data successfully', () async {
      final notifier = container.read(accountProvider.notifier);

      // Wait for the async operation to complete
      await Future.delayed(const Duration(milliseconds: 1000));

      // The state should eventually be data
      final state = container.read(accountProvider);
      expect(state, isA<AsyncData<Account>>());
      
      state.whenData((account) {
        expect(account.user.name, 'Tayyab Sohail');
        expect(account.cards.length, greaterThan(0));
        expect(account.transactions.length, greaterThan(0));
        expect(account.totalBalance, 1200);
      });
    });

    test('AccountNotifier refresh resets state to loading then data', () async {
      final notifier = container.read(accountProvider.notifier);

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 1000));

      // Call refresh
      notifier.refresh();

      // Should be loading
      expect(container.read(accountProvider), isA<AsyncLoading>());

      // Wait for refresh to complete
      await Future.delayed(const Duration(milliseconds: 1000));

      // Should be data again
      final state = container.read(accountProvider);
      expect(state, isA<AsyncData<Account>>());
    });

    test('Account data has correct structure', () async {
      final notifier = container.read(accountProvider.notifier);

      await Future.delayed(const Duration(milliseconds: 1000));

      final state = container.read(accountProvider);
      state.whenData((account) {
        // Check user
        expect(account.user.id, '1');
        expect(account.user.name, 'Tayyab Sohail');
        expect(account.user.email, 'tayyabsohaild@gmail.com');
        expect(account.user.title, 'UI/UX Designer');

        // Check cards
        expect(account.cards.length, 4);
        expect(account.cards.where((c) => c.type == CardType.physical).length, 2);
        expect(account.cards.where((c) => c.type == CardType.virtual).length, 2);

        // Check transactions
        expect(account.transactions.length, 5);
        expect(account.transactions.where((t) => t.type == TransactionType.income).length, greaterThan(0));
        expect(account.transactions.where((t) => t.type == TransactionType.expense).length, greaterThan(0));

        // Check total balance
        expect(account.totalBalance, 1200);
      });
    });

    test('Card details are correct', () async {
      final notifier = container.read(accountProvider.notifier);

      await Future.delayed(const Duration(milliseconds: 1000));

      final state = container.read(accountProvider);
      state.whenData((account) {
        final firstCard = account.cards.first;
        expect(firstCard.id, '1');
        expect(firstCard.cardNumber, '5555555555553466');
        expect(firstCard.holderName, 'Tayyab Sohail');
        expect(firstCard.expiryDate, '12/02/2024');
        expect(firstCard.cvv, '663');
        expect(firstCard.balance, 1200);
        expect(firstCard.type, CardType.physical);
        expect(firstCard.cardBrand, 'mastercard');
      });
    });

    test('Transaction details are correct', () async {
      final notifier = container.read(accountProvider.notifier);

      await Future.delayed(const Duration(milliseconds: 1000));

      final state = container.read(accountProvider);
      state.whenData((account) {
        final firstTransaction = account.transactions.first;
        expect(firstTransaction.id, '1');
        expect(firstTransaction.name, 'E wallet');
        expect(firstTransaction.description, 'Transfer to E wallet');
        expect(firstTransaction.amount, 100);
        expect(firstTransaction.type, TransactionType.income);
      });
    });
  });

  group('AccountProvider Integration Tests', () {
    test('Provider returns consistent data on multiple reads', () async {
      final container = ProviderContainer();

      await Future.delayed(const Duration(milliseconds: 1000));

      final state1 = container.read(accountProvider);
      final state2 = container.read(accountProvider);

      state1.whenData((account1) {
        state2.whenData((account2) {
          expect(account1.user.name, account2.user.name);
          expect(account1.cards.length, account2.cards.length);
          expect(account1.totalBalance, account2.totalBalance);
        });
      });

      container.dispose();
    });
  });
}