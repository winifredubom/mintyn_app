enum CardType { physical, virtual }

class CardDetails {
  final String id;
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final String cvv;
  final double balance;
  final CardType type;
  final String cardBrand; // mastercard, visa, etc.

  CardDetails({
    required this.id,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.cvv,
    required this.balance,
    required this.type,
    required this.cardBrand,
  });

  String get maskedCardNumber {
    return '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';
  }

  factory CardDetails.fromJson(Map<String, dynamic> json) {
    return CardDetails(
      id: json['id'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      holderName: json['holderName'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      cvv: json['cvv'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      type: json['type'] == 'virtual' ? CardType.virtual : CardType.physical,
      cardBrand: json['cardBrand'] ?? 'mastercard',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'holderName': holderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'balance': balance,
      'type': type.toString().split('.').last,
      'cardBrand': cardBrand,
    };
  }
}
