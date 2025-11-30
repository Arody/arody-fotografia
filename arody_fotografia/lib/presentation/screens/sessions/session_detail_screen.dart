import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/sessions_provider.dart';

class SessionDetailScreen extends ConsumerWidget {
  final String sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionDetailProvider(sessionId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la Sesión')),
      body: sessionAsync.when(
        data: (session) {
          final dateFormat = DateFormat('EEEE, d ' 'de' ' MMMM, yyyy', 'es');
          final timeFormat = DateFormat('h:mm a');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.sessionType.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(dateFormat.format(session.sessionDate.toLocal())),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 8),
                    Text(timeFormat.format(session.sessionDate.toLocal())),
                  ],
                ),
                if (session.location != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 8),
                      Text(session.location!),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                const Text(
                  'Estado',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(session.status.toUpperCase()),
                const SizedBox(height: 24),
                if (session.notes != null) ...[
                  const Text(
                    'Notas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(session.notes!),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
