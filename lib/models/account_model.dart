import 'user_model.dart';
import 'card_model.dart';
import 'transaction_model.dart';

class Account {
  final User user;
  final List<CardDetails> cards;
  final List<Transaction> transactions;
  final double totalBalance;

  Account({
    required this.user,
    required this.cards,
    required this.transactions,
    required this.totalBalance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      user: User.fromJson(json['user'] ?? {}),
      cards: (json['cards'] as List?)?.map((c) => CardDetails.fromJson(c)).toList() ?? [],
      transactions: (json['transactions'] as List?)?.map((t) => Transaction.fromJson(t)).toList() ?? [],
      totalBalance: (json['totalBalance'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'cards': cards.map((c) => c.toJson()).toList(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'totalBalance': totalBalance,
    };
  }
}
