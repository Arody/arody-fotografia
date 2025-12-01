// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  sessionId: json['sessionId'] as String?,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  status: json['status'] as String,
  paymentDate: json['paymentDate'] == null
      ? null
      : DateTime.parse(json['paymentDate'] as String),
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  description: json['description'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'sessionId': instance.sessionId,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'paymentDate': instance.paymentDate?.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
    };
