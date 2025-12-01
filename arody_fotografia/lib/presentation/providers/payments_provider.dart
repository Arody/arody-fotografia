import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/payments_repository_impl.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payments_repository.dart';

part 'payments_provider.g.dart';

@riverpod
PaymentsRepository paymentsRepository(Ref ref) {
  return PaymentsRepositoryImpl(Supabase.instance.client);
}

@riverpod
Future<List<Payment>> paymentsList(Ref ref) async {
  final repository = ref.watch(paymentsRepositoryProvider);
  return repository.getPayments();
}
