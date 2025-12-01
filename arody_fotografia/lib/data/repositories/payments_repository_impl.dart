import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payments_repository.dart';
import '../models/payment_model.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  final SupabaseClient _supabaseClient;

  PaymentsRepositoryImpl(this._supabaseClient);

  @override
  Future<List<Payment>> getPayments() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    final response = await _supabaseClient
        .from('payments')
        .select()
        .eq('client_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => PaymentModel.fromJson(e)).toList();
  }

  @override
  Future<Payment> getPaymentById(String id) async {
    final response = await _supabaseClient
        .from('payments')
        .select()
        .eq('id', id)
        .single();

    return PaymentModel.fromJson(response);
  }
}
