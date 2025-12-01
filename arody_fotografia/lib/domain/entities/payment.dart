import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String clientId;
  final String? sessionId;
  final double amount;
  final String currency;
  final String status;
  final DateTime? paymentDate;
  final DateTime? dueDate;
  final String? description;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.clientId,
    this.sessionId,
    required this.amount,
    required this.currency,
    required this.status,
    this.paymentDate,
    this.dueDate,
    this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        clientId,
        sessionId,
        amount,
        currency,
        status,
        paymentDate,
        dueDate,
        description,
        createdAt,
      ];
}
