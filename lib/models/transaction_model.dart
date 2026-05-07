enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String name;
  final String description;
  final double amount;
  final TransactionType type;
  final DateTime dateTime;
  final String? icon; // icon code or path

  Transaction({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.type,
    required this.dateTime,
    this.icon,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      type: json['type'] == 'expense'
          ? TransactionType.expense
          : TransactionType.income,
      dateTime: DateTime.parse(json['dateTime'] ?? DateTime.now().toString()),
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'type': type.toString().split('.').last,
      'dateTime': dateTime.toIso8601String(),
      'icon': icon,
    };
  }
}
