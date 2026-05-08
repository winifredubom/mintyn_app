import 'package:flutter_test/flutter_test.dart';
import 'package:mintyn_app/models/account_model.dart';
import 'package:mintyn_app/models/card_model.dart';
import 'package:mintyn_app/models/transaction_model.dart';
import 'package:mintyn_app/models/user_model.dart';
import 'package:mintyn_app/utils/formatters.dart';

void main() {
  group('User Model Tests', () {
    test('User.fromJson creates correct object with all fields', () {
      final json = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'title': 'Developer',
        'avatarUrl': 'https://example.com/avatar.jpg',
      };
      final user = User.fromJson(json);
      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.title, 'Developer');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
    });

    test('User.fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};
      final user = User.fromJson(json);
      expect(user.id, '');
      expect(user.name, '');
      expect(user.email, '');
      expect(user.title, '');
      expect(user.avatarUrl, isNull);
    });

    test('User.fromJson handles null avatarUrl', () {
      final json = {
        'id': '2',
        'name': 'Jane Smith',
        'email': 'jane@example.com',
        'title': 'Designer',
        'avatarUrl': null,
      };
      final user = User.fromJson(json);
      expect(user.avatarUrl, isNull);
    });

    test('User.toJson returns correct map', () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        title: 'Developer',
        avatarUrl: 'https://example.com/avatar.jpg',
      );
      final json = user.toJson();
      expect(json['id'], '1');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['title'], 'Developer');
      expect(json['avatarUrl'], 'https://example.com/avatar.jpg');
    });

    test('User.toJson handles null avatarUrl', () {
      final user = User(
        id: '2',
        name: 'Jane Smith',
        email: 'jane@example.com',
        title: 'Designer',
      );
      final json = user.toJson();
      expect(json['avatarUrl'], isNull);
    });
  });

  group('CardDetails Model Tests', () {
    test('CardDetails.fromJson creates correct object for physical card', () {
      final json = {
        'id': '1',
        'cardNumber': '5555555555551234',
        'holderName': 'John Doe',
        'expiryDate': '12/25',
        'cvv': '123',
        'balance': 1000.0,
        'type': 'physical',
        'cardBrand': 'mastercard',
      };
      final card = CardDetails.fromJson(json);
      expect(card.id, '1');
      expect(card.cardNumber, '5555555555551234');
      expect(card.holderName, 'John Doe');
      expect(card.expiryDate, '12/25');
      expect(card.cvv, '123');
      expect(card.balance, 1000.0);
      expect(card.type, CardType.physical);
      expect(card.cardBrand, 'mastercard');
    });

    test('CardDetails.fromJson creates correct object for virtual card', () {
      final json = {
        'id': '2',
        'cardNumber': '5555555555555678',
        'holderName': 'Jane Smith',
        'expiryDate': '06/26',
        'cvv': '456',
        'balance': 2500.50,
        'type': 'virtual',
        'cardBrand': 'visa',
      };
      final card = CardDetails.fromJson(json);
      expect(card.type, CardType.virtual);
      expect(card.cardBrand, 'visa');
      expect(card.balance, 2500.50);
    });

    test('CardDetails.fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};
      final card = CardDetails.fromJson(json);
      expect(card.id, '');
      expect(card.cardNumber, '');
      expect(card.holderName, '');
      expect(card.expiryDate, '');
      expect(card.cvv, '');
      expect(card.balance, 0.0);
      expect(card.type, CardType.physical); // default
      expect(card.cardBrand, 'mastercard'); // default
    });

    test('CardDetails.maskedCardNumber returns correct format for 16-digit card', () {
      final card = CardDetails(
        id: '1',
        cardNumber: '5555555555551234',
        holderName: 'Test',
        expiryDate: '12/25',
        cvv: '123',
        balance: 100,
        type: CardType.physical,
        cardBrand: 'mastercard',
      );
      expect(card.maskedCardNumber, '•••• •••• •••• 1234');
    });

    test('CardDetails.maskedCardNumber returns correct format for different card', () {
      final card = CardDetails(
        id: '2',
        cardNumber: '4111111111111111',
        holderName: 'Test',
        expiryDate: '12/25',
        cvv: '123',
        balance: 100,
        type: CardType.virtual,
        cardBrand: 'visa',
      );
      expect(card.maskedCardNumber, '•••• •••• •••• 1111');
    });

    test('CardDetails.toJson returns correct map for physical card', () {
      final card = CardDetails(
        id: '1',
        cardNumber: '5555555555551234',
        holderName: 'John Doe',
        expiryDate: '12/25',
        cvv: '123',
        balance: 1000.0,
        type: CardType.physical,
        cardBrand: 'mastercard',
      );
      final json = card.toJson();
      expect(json['id'], '1');
      expect(json['cardNumber'], '5555555555551234');
      expect(json['type'], 'physical');
      expect(json['cardBrand'], 'mastercard');
    });

    test('CardDetails.toJson returns correct map for virtual card', () {
      final card = CardDetails(
        id: '2',
        cardNumber: '4111111111111111',
        holderName: 'Jane Smith',
        expiryDate: '06/26',
        cvv: '456',
        balance: 2500.50,
        type: CardType.virtual,
        cardBrand: 'visa',
      );
      final json = card.toJson();
      expect(json['type'], 'virtual');
      expect(json['cardBrand'], 'visa');
      expect(json['balance'], 2500.50);
    });
  });

  group('Transaction Model Tests', () {
    test('Transaction.fromJson creates correct income transaction', () {
      final json = {
        'id': '1',
        'name': 'Salary',
        'description': 'Monthly salary',
        'amount': 5000.0,
        'type': 'income',
        'dateTime': '2024-01-15T10:30:00.000',
        'icon': 'account_balance',
      };
      final transaction = Transaction.fromJson(json);
      expect(transaction.id, '1');
      expect(transaction.name, 'Salary');
      expect(transaction.description, 'Monthly salary');
      expect(transaction.amount, 5000.0);
      expect(transaction.type, TransactionType.income);
      expect(transaction.icon, 'account_balance');
    });

    test('Transaction.fromJson creates correct expense transaction', () {
      final json = {
        'id': '2',
        'name': 'Shopping',
        'description': 'Grocery shopping',
        'amount': 150.75,
        'type': 'expense',
        'dateTime': '2024-01-16T14:20:00.000',
        'icon': null,
      };
      final transaction = Transaction.fromJson(json);
      expect(transaction.type, TransactionType.expense);
      expect(transaction.amount, 150.75);
      expect(transaction.icon, isNull);
    });

    test('Transaction.fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};
      final transaction = Transaction.fromJson(json);
      expect(transaction.id, '');
      expect(transaction.name, '');
      expect(transaction.description, '');
      expect(transaction.amount, 0.0);
      expect(transaction.type, TransactionType.income); // default
      expect(transaction.icon, isNull);
    });

    test('Transaction.fromJson handles invalid date with fallback', () {
      final json = {
        'id': '3',
        'name': 'Test',
        'description': 'Test',
        'amount': 100.0,
        'type': 'income',
        'dateTime': 'invalid-date',
      };
      final transaction = Transaction.fromJson(json);
      expect(transaction.id, '3');
      expect(transaction.dateTime, isA<DateTime>());
    });

    test('Transaction.toJson returns correct map for income', () {
      final transaction = Transaction(
        id: '1',
        name: 'Salary',
        description: 'Monthly salary',
        amount: 5000.0,
        type: TransactionType.income,
        dateTime: DateTime(2024, 1, 15, 10, 30),
        icon: 'account_balance',
      );
      final json = transaction.toJson();
      expect(json['id'], '1');
      expect(json['type'], 'income');
      expect(json['amount'], 5000.0);
      expect(json['icon'], 'account_balance');
    });

    test('Transaction.toJson returns correct map for expense', () {
      final transaction = Transaction(
        id: '2',
        name: 'Shopping',
        description: 'Grocery shopping',
        amount: 150.75,
        type: TransactionType.expense,
        dateTime: DateTime(2024, 1, 16, 14, 20),
      );
      final json = transaction.toJson();
      expect(json['type'], 'expense');
      expect(json['amount'], 150.75);
      expect(json['icon'], isNull);
    });
  });

  group('Account Model Tests', () {
    test('Account.fromJson creates correct object with full data', () {
      final json = {
        'user': {
          'id': '1',
          'name': 'John Doe',
          'email': 'john@example.com',
          'title': 'Developer',
          'avatarUrl': null,
        },
        'cards': [
          {
            'id': '1',
            'cardNumber': '5555555555551234',
            'holderName': 'John Doe',
            'expiryDate': '12/25',
            'cvv': '123',
            'balance': 1000.0,
            'type': 'physical',
            'cardBrand': 'mastercard',
          }
        ],
        'transactions': [
          {
            'id': '1',
            'name': 'Test Transaction',
            'description': 'Test desc',
            'amount': 100.0,
            'type': 'income',
            'dateTime': '2024-01-01T00:00:00.000',
            'icon': null,
          }
        ],
        'totalBalance': 1000.0,
      };
      final account = Account.fromJson(json);
      expect(account.user.name, 'John Doe');
      expect(account.cards.length, 1);
      expect(account.cards.first.cardNumber, '5555555555551234');
      expect(account.transactions.length, 1);
      expect(account.transactions.first.name, 'Test Transaction');
      expect(account.totalBalance, 1000.0);
    });

    test('Account.fromJson handles empty json', () {
      final account = Account.fromJson({});
      expect(account.user.name, '');
      expect(account.cards.isEmpty, true);
      expect(account.transactions.isEmpty, true);
      expect(account.totalBalance, 0.0);
    });

    test('Account.fromJson handles null lists with empty defaults', () {
      final json = {
        'user': {'id': '1', 'name': 'Test', 'email': 'test@test.com', 'title': 'Tester'},
        'cards': null,
        'transactions': null,
        'totalBalance': 0.0,
      };
      final account = Account.fromJson(json);
      expect(account.cards.isEmpty, true);
      expect(account.transactions.isEmpty, true);
    });

    test('Account.fromJson handles missing lists with empty defaults', () {
      final json = {
        'user': {'id': '1', 'name': 'Test', 'email': 'test@test.com', 'title': 'Tester'},
        'totalBalance': 500.0,
      };
      final account = Account.fromJson(json);
      expect(account.cards.isEmpty, true);
      expect(account.transactions.isEmpty, true);
      expect(account.totalBalance, 500.0);
    });

    test('Account.toJson returns correct map', () {
      final user = User(
        id: '1',
        name: 'John',
        email: 'john@test.com',
        title: 'Dev',
      );
      final card = CardDetails(
        id: '1',
        cardNumber: '1234567890123456',
        holderName: 'John',
        expiryDate: '12/25',
        cvv: '123',
        balance: 500,
        type: CardType.physical,
        cardBrand: 'mastercard',
      );
      final transaction = Transaction(
        id: '1',
        name: 'Test',
        description: 'Test',
        amount: 100,
        type: TransactionType.income,
        dateTime: DateTime(2024, 1, 1),
      );
      final account = Account(
        user: user,
        cards: [card],
        transactions: [transaction],
        totalBalance: 500,
      );
      final json = account.toJson();
      expect(json['user']['name'], 'John');
      expect((json['cards'] as List).length, 1);
      expect((json['transactions'] as List).length, 1);
      expect(json['totalBalance'], 500);
    });
  });

  group('AppFormatters Tests', () {
    test('formatCurrency formats correctly with default symbol', () {
      expect(AppFormatters.formatCurrency(1234.56), '\$1234.56');
      expect(AppFormatters.formatCurrency(0), '\$0.00');
      expect(AppFormatters.formatCurrency(-100.50), '\$-100.50');
    });

    test('formatCurrency formats correctly with custom symbol', () {
      expect(AppFormatters.formatCurrency(1234.56, symbol: '€'), '€1234.56');
      expect(AppFormatters.formatCurrency(100, symbol: '£'), '£100.00');
    });

    test('formatCompactNumber formats large numbers correctly', () {
      expect(AppFormatters.formatCompactNumber(1200), '1.2K');
      expect(AppFormatters.formatCompactNumber(15000), '15.0K');
      expect(AppFormatters.formatCompactNumber(1000000), '1.0M');
      expect(AppFormatters.formatCompactNumber(2500000), '2.5M');
      expect(AppFormatters.formatCompactNumber(500), '500');
      expect(AppFormatters.formatCompactNumber(999), '999');
    });

    test('formatDateTime formats correctly', () {
      final dateTime = DateTime(2024, 1, 15, 10, 30);
      final formatted = AppFormatters.formatDateTime(dateTime);
      expect(formatted, contains('10:30'));
      expect(formatted, contains('01-15-2024'));
    });

    test('formatDate formats correctly', () {
      final dateTime = DateTime(2024, 1, 15);
      expect(AppFormatters.formatDate(dateTime), 'Jan 15, 2024');
    });

    test('formatTime formats correctly', () {
      final dateTime = DateTime(2024, 1, 15, 14, 30);
      final formatted = AppFormatters.formatTime(dateTime);
      // Accept either 12-hour or 24-hour format
      expect(formatted, anyOf([contains('02:30'), contains('14:30')]));
    });

    test('formatRelativeTime returns correct values', () {
      final now = DateTime.now();
      expect(AppFormatters.formatRelativeTime(now), 'Just now');
      expect(AppFormatters.formatRelativeTime(now.subtract(const Duration(minutes: 5))), '5m ago');
      expect(AppFormatters.formatRelativeTime(now.subtract(const Duration(hours: 3))), '3h ago');
      expect(AppFormatters.formatRelativeTime(now.subtract(const Duration(days: 3))), '3d ago');
    });

    test('formatPhoneNumber formats correctly', () {
      expect(AppFormatters.formatPhoneNumber('1234567890'), '(123) 456-7890');
      expect(AppFormatters.formatPhoneNumber('123-456-7890'), '(123) 456-7890');
      expect(AppFormatters.formatPhoneNumber('(123) 456-7890'), '(123) 456-7890');
      expect(AppFormatters.formatPhoneNumber('12345'), '12345'); // Not 10 digits
    });
  });
}