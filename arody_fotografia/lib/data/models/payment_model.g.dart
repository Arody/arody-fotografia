// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
  id: json['id'] as String,
  clientId: json['client_id'] as String,
  sessionId: json['session_id'] as String?,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  status: json['status'] as String,
  paymentDate: json['payment_date'] == null
      ? null
      : DateTime.parse(json['payment_date'] as String),
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
  description: json['description'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_id': instance.clientId,
      'session_id': instance.sessionId,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'payment_date': instance.paymentDate?.toIso8601String(),
      'due_date': instance.dueDate?.toIso8601String(),
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
    };
