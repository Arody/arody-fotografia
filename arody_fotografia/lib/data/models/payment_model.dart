import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/payment.dart';

part 'payment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.clientId,
    super.sessionId,
    required super.amount,
    required super.currency,
    required super.status,
    super.paymentDate,
    super.dueDate,
    super.description,
    required super.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
