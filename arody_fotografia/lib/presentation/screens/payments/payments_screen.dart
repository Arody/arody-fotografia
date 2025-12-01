import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/payment.dart';
import '../../providers/payments_provider.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pagos')),
      body: paymentsAsync.when(
        data: (payments) {
          if (payments.isEmpty) {
            return const Center(child: Text('No hay pagos registrados.'));
          }

          // Calculate totals
          final totalPending = payments
              .where((p) => p.status == 'pending')
              .fold(0.0, (sum, p) => sum + p.amount);
          
          final totalPaid = payments
              .where((p) => p.status == 'paid')
              .fold(0.0, (sum, p) => sum + p.amount);

          return Column(
            children: [
              _buildSummaryCard(context, totalPending, totalPaid),
              Expanded(
                child: ListView.builder(
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    return PaymentCard(payment: payments[index]);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, double pending, double paid) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text('Pendiente', style: TextStyle(color: Colors.orange)),
                Text(
                  currencyFormat.format(pending),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            Container(height: 40, width: 1, color: Colors.grey),
            Column(
              children: [
                const Text('Pagado', style: TextStyle(color: Colors.green)),
                Text(
                  currencyFormat.format(paid),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final Payment payment;

  const PaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM, yyyy', 'es');
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    Color statusColor;
    String statusLabel;

    switch (payment.status) {
      case 'paid':
        statusColor = Colors.green;
        statusLabel = 'PAGADO';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusLabel = 'PENDIENTE';
        break;
      case 'overdue':
        statusColor = Colors.red;
        statusLabel = 'VENCIDO';
        break;
      default:
        statusColor = Colors.grey;
        statusLabel = payment.status.toUpperCase();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.2),
          child: Icon(Icons.attach_money, color: statusColor),
        ),
        title: Text(payment.description ?? 'Pago de Sesión'),
        subtitle: Text(payment.dueDate != null 
            ? 'Vence: ${dateFormat.format(payment.dueDate!)}' 
            : 'Fecha: ${dateFormat.format(payment.createdAt)}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(payment.amount),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              statusLabel,
              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
