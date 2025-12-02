import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../common/session_card.dart';
import '../../providers/sessions_provider.dart';
import '../../providers/current_profile_provider.dart';

class SessionsListScreen extends ConsumerWidget {
  const SessionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdminAsync = ref.watch(isCurrentUserAdminProvider);
    final now = DateTime.now();

    return isAdminAsync.when(
      data: (isAdmin) {
        final sessionsAsync = isAdmin
            ? ref.watch(allSessionsListProvider)
            : ref.watch(sessionsListProvider);

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: Text(isAdmin ? 'Todas las Sesiones' : 'Mis Sesiones'),
            actions: [
              if (!isAdmin)
                IconButton(
                  onPressed: () => context.push('/booking'),
                  icon: const Icon(Icons.add),
                  tooltip: 'Nueva Sesión',
                ),
              if (isAdmin)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: const Text(
                        'ADMIN',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              if (isAdmin) {
                ref.invalidate(allSessionsListProvider);
              } else {
                ref.invalidate(sessionsListProvider);
              }
            },
            child: sessionsAsync.when(
              data: (sessions) {
                if (sessions.isEmpty) {
                  return _EmptyState(
                    onBooking: () => context.push('/booking'),
                    isAdmin: isAdmin,
                  );
                }

            final futureSessions = sessions
                .where((s) => s.sessionDate.isAfter(now))
                .toList();
            final pastSessions = sessions
                .where((s) => s.sessionDate.isBefore(now))
                .toList();

                return CustomScrollView(
                  slivers: [
                    if (futureSessions.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: Row(
                        children: [
                          const Text(
                                'Próximas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${futureSessions.length}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final session = futureSessions[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SessionCard(
                              session: session,
                              onTap: () => context.push('/sessions/${session.id}'),
                            ),
                          );
                        },
                        childCount: futureSessions.length,
                      ),
                    ),
                  ),
                ],
                if (pastSessions.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                      child: Row(
                        children: [
                          const Text(
                            'Pasadas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${pastSessions.length}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final session = pastSessions[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SessionCard(
                              session: session,
                              onTap: () => context.push('/sessions/${session.id}'),
                            ),
                          );
                        },
                        childCount: pastSessions.length,
                      ),
                    ),
                  ),
                ],
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Error al cargar sesiones',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (isAdmin) {
                        ref.invalidate(allSessionsListProvider);
                      } else {
                        ref.invalidate(sessionsListProvider);
                      }
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        body: Center(
          child: Text('Error al verificar permisos'),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onBooking;
  final bool isAdmin;

  const _EmptyState({
    required this.onBooking,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.photo_camera_outlined,
                size: 60,
                color: AppTheme.accentColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No tienes sesiones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isAdmin 
                  ? 'No hay sesiones registradas en el sistema'
                  : 'Comienza reservando tu primera sesión fotográfica',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isAdmin)
              ElevatedButton.icon(
                onPressed: onBooking,
                icon: const Icon(Icons.add),
                label: const Text('Reservar Sesión'),
              ),
          ],
        ),
      ),
    );
  }
}
