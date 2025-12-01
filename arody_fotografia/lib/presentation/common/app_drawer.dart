import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header con información del usuario
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profileAsync.when(
                    data: (profile) {
                      return CircleAvatar(
                        radius: 32,
                        backgroundColor: AppTheme.accentColor,
                        child: Text(
                          _getInitials(profile?.fullName),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                    loading: () => CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.grey.shade300,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, __) => CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person, size: 32),
                    ),
                  ),
                  const SizedBox(height: 16),
                  profileAsync.when(
                    data: (profile) {
                      return Text(
                        profile?.fullName ?? user?.email?.split('@')[0] ?? 'Usuario',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      );
                    },
                    loading: () => Container(
                      height: 20,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    error: (_, __) => Text(
                      user?.email?.split('@')[0] ?? 'Usuario',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerItem(
                    icon: Icons.person_outline,
                    title: 'Mi Cuenta',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/account');
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _DrawerItem(
                    icon: Icons.photo_library_outlined,
                    title: 'Mis Sesiones',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/sessions');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.payment_outlined,
                    title: 'Mis Pagos',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/payments');
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _DrawerItem(
                    icon: Icons.help_outline,
                    title: 'Ayuda y Soporte',
                    onTap: () {
                      // TODO: Implementar ayuda
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            
            // Logout button
            const Divider(height: 1),
            _DrawerItem(
              icon: Icons.logout,
              title: 'Cerrar Sesión',
              textColor: AppTheme.errorColor,
              iconColor: AppTheme.errorColor,
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog(context, ref);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(signOutProvider.notifier).signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppTheme.textPrimary,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppTheme.textPrimary,
          letterSpacing: -0.2,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}

