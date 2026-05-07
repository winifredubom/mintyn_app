// Mock data provider
// This will be converted to use Riverpod or Provider pattern

import '../models/account_model.dart';
import '../models/user_model.dart';
import '../models/card_model.dart';
import '../models/transaction_model.dart';

class AccountProvider {
  static Account getMockAccount() {
    final user = User(
      id: '1',
      name: 'Tayyab Sohail',
      email: 'tayyabsohaild@gmail.com',
      title: 'UI/UX Designer',
      avatarUrl: null,
    );

    final cards = [
      CardDetails(
        id: '1',
        cardNumber: '5555555555553466',
        holderName: 'Tayyab Sohail',
        expiryDate: '12/02/2024',
        cvv: '663',
        balance: 1200,
        type: CardType.physical,
        cardBrand: 'mastercard',
      ),
      CardDetails(
        id: '2',
        cardNumber: '5555555555554567',
        holderName: 'Tayyab Sohail',
        expiryDate: '12/02/2025',
        cvv: '664',
        balance: 2500,
        type: CardType.virtual,
        cardBrand: 'mastercard',
      ),
      CardDetails(
        id: '3',
        cardNumber: '5555555555555678',
        holderName: 'Tayyab Sohail',
        expiryDate: '12/02/2026',
        cvv: '665',
        balance: 3200,
        type: CardType.physical,
        cardBrand: 'mastercard',
      ),
    ];

    final transactions = [
      Transaction(
        id: '1',
        name: 'E wallet',
        description: 'Transfer to E wallet',
        amount: 100,
        type: TransactionType.income,
        dateTime: DateTime(2024, 12, 12, 12, 10),
      ),
      Transaction(
        id: '2',
        name: 'Online Shopping',
        description: 'Online Shopping',
        amount: 100,
        type: TransactionType.expense,
        dateTime: DateTime(2024, 12, 12, 12, 10),
      ),
      Transaction(
        id: '3',
        name: 'E wallet',
        description: 'Transfer to E wallet',
        amount: 100,
        type: TransactionType.income,
        dateTime: DateTime(2024, 12, 12, 12, 10),
      ),
      Transaction(
        id: '4',
        name: 'Banking Fee',
        description: 'Monthly banking fee',
        amount: 100,
        type: TransactionType.income,
        dateTime: DateTime(2024, 12, 12, 12, 10),
      ),
      Transaction(
        id: '5',
        name: 'Saving',
        description: 'Transfer to savings',
        amount: 200,
        type: TransactionType.expense,
        dateTime: DateTime(2024, 12, 12, 12, 10),
      ),
    ];

    return Account(
      user: user,
      cards: cards,
      transactions: transactions,
      totalBalance: 1200,
    );
  }
}
