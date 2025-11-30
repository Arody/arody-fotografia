import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arody Fotografía'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Supabase.instance.client.auth.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Bienvenido a Arody Fotografía!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.push('/sessions'),
              child: const Text('Mis Sesiones'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/inspiration'),
              child: const Text('Inspiración'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/calendar'),
              child: const Text('Calendario'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/booking'),
              child: const Text('Reservar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
