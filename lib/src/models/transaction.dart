import 'dart:convert';

class Transaction {
  final String id;
  final double amount;
  final DateTime timestamp;
  final String cardBrand;
  final String lastFour;
  final String authCode;
  final String status;

  Transaction({
    required this.id,
    required this.amount,
    required this.timestamp,
    required this.cardBrand,
    required this.lastFour,
    required this.authCode,
    this.status = 'APROBADO',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'cardBrand': cardBrand,
      'lastFour': lastFour,
      'authCode': authCode,
      'status': status,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
      cardBrand: map['cardBrand'] ?? 'VISA',
      lastFour: map['lastFour'] ?? '8492',
      authCode: map['authCode'] ?? '',
      status: map['status'] ?? 'APROBADO',
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));
}
