import '../entities/payment.dart';

abstract class PaymentsRepository {
  Future<List<Payment>> getPayments();
  Future<Payment> getPaymentById(String id);
}
