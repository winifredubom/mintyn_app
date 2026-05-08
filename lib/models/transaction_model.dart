enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String name;
  final String description;
  final double amount;
  final TransactionType type;
  final DateTime dateTime;
  final String? icon; 

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
      dateTime: _parseDateTime(json['dateTime']),
      icon: json['icon'],
    );
  }

  static DateTime _parseDateTime(dynamic dateTimeStr) {
    if (dateTimeStr is String) {
      try {
        return DateTime.parse(dateTimeStr);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
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
