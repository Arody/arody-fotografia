import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/quote_provider.dart';

class QuoteCalculatorCard extends ConsumerWidget {
  final List<String> availableLocations;
  const QuoteCalculatorCard({super.key, required this.availableLocations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(quoteProvider);
    final notifier = ref.read(quoteProvider.notifier);
    final currency = NumberFormat.simpleCurrency(locale: 'es_MX');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cotización',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: quote.coupleNames,
              decoration: const InputDecoration(labelText: 'Nombres de la pareja'),
              onChanged: notifier.setCoupleNames,
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 360;
                if (narrow) {
                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: quote.location,
                        decoration: const InputDecoration(labelText: 'Ubicación principal'),
                    hint: const Text('Selecciona ubicación'),
                    items: [
                      ...availableLocations.map((l) => DropdownMenuItem(value: l, child: Text(l))),
                    ],
                        isExpanded: true,
                        onChanged: notifier.setLocation,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: quote.guestCount?.toString() ?? '',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Invitados (informativo)'),
                        onChanged: (v) {
                          final n = int.tryParse(v);
                          notifier.setGuestCount(n);
                        },
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: quote.location,
                        decoration: const InputDecoration(labelText: 'Ubicación principal'),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Selecciona ubicación')),
                          ...availableLocations.map((l) => DropdownMenuItem(value: l, child: Text(l))),
                        ],
                        isExpanded: true,
                        onChanged: notifier.setLocation,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: quote.guestCount?.toString() ?? '',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Invitados (informativo)'),
                        onChanged: (v) {
                          final n = int.tryParse(v);
                          notifier.setGuestCount(n);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Horas de cobertura'),
                const SizedBox(width: 8),
                Text('${quote.hours}'),
                const Spacer(),
                Text('${notifier.imagesCount} imágenes'),
              ],
            ),
            Slider(
              min: 2,
              max: 10,
              divisions: 8,
              value: quote.hours.toDouble(),
              label: '${quote.hours}h',
              onChanged: (v) => notifier.setHours(v.round()),
            ),
            const SizedBox(height: 8),
            const Text('Sesiones adicionales'),
            const SizedBox(height: 8),
            _AdditionalSessionRow(type: 'preBoda', availableLocations: availableLocations),
            _AdditionalSessionRow(type: 'postBoda', availableLocations: availableLocations),
            _AdditionalSessionRow(type: 'studio', availableLocations: const []),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: quote.discountCode ?? '',
                    decoration: const InputDecoration(labelText: 'Código de descuento'),
                    onFieldSubmitted: (v) => notifier.setDiscountCode(v.isEmpty ? null : v.trim()),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => notifier.setDiscountCode(quote.discountCode?.trim()),
                  child: const Text('Aplicar'),
                )
              ],
            ),
            const Divider(height: 24),
            _QuoteSummary(currency: currency),
          ],
        ),
      ),
    );
  }
}

class _AdditionalSessionRow extends ConsumerWidget {
  final String type;
  final List<String> availableLocations;
  const _AdditionalSessionRow({required this.type, required this.availableLocations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(quoteProvider);
    final notifier = ref.read(quoteProvider.notifier);
    final enabled = quote.sessions.any((s) => s.type == type);
    final selected = quote.sessions.firstWhere(
      (s) => s.type == type,
      orElse: () => const AdditionalSession(type: ''),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 360;
        if (narrow) {
          return Column(
            children: [
              CheckboxListTile(
                value: enabled,
                title: Text(type.toUpperCase()),
                onChanged: (_) => notifier.toggleSession(type),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (type != 'studio')
                DropdownButtonFormField<String>(
                  initialValue: enabled ? selected.location : null,
                  decoration: const InputDecoration(labelText: 'Ubicación'),
              hint: const Text('Selecciona'),
              items: [
                ...availableLocations.map((l) => DropdownMenuItem(value: l, child: Text(l))),
              ],
                  isExpanded: true,
                  onChanged: enabled ? (v) => notifier.setSessionLocation(type, v) : null,
                ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                value: enabled,
                title: Text(type.toUpperCase()),
                onChanged: (_) => notifier.toggleSession(type),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            if (type != 'studio')
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: enabled ? selected.location : null,
                  decoration: const InputDecoration(labelText: 'Ubicación'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Selecciona')),
                    ...availableLocations.map((l) => DropdownMenuItem(value: l, child: Text(l))),
                  ],
                  isExpanded: true,
                  onChanged: enabled ? (v) => notifier.setSessionLocation(type, v) : null,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _QuoteSummary extends ConsumerWidget {
  final NumberFormat currency;
  const _QuoteSummary({required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(quoteProvider.notifier);
    final quote = ref.watch(quoteProvider);
    final base = notifier.baseCost;
    final loc = notifier.weddingLocationCost;
    final sessions = notifier.sessionsCost;
    final totalBefore = notifier.totalBeforeAdjustment;
    final adjusted = notifier.adjustedTotalCost;
    final finalCost = notifier.finalCost;
    final deposit = notifier.deposit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Costo base'),
            Text(currency.format(base)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ubicación principal'),
            Text(currency.format(loc)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Sesiones adicionales'),
            Text(currency.format(sessions)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal'),
            Text(currency.format(totalBefore)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ajuste temporada (${(notifier.adjustmentPercentage * 100).toStringAsFixed(0)}%)'),
            Text(currency.format(adjusted - totalBefore)),
          ],
        ),
        const Divider(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Descuento (${(quote.discountPercentage * 100).toStringAsFixed(0)}%)'),
            Text('-${currency.format(adjusted - finalCost)}'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total'),
            Text(currency.format(finalCost)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 165, 0, 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Apartado (30%)'),
              Text(currency.format(deposit)),
            ],
          ),
        ),
      ],
    );
  }
}
