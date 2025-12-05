import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdditionalSession {
  final String type;
  final String? location;
  final DateTime? date;
  const AdditionalSession({required this.type, this.location, this.date});
}

class QuoteState {
  final String coupleNames;
  final DateTime? date;
  final String? location;
  final int? guestCount;
  final int hours;
  final List<AdditionalSession> sessions;
  final String? discountCode;
  final double discountPercentage;
  final String? currentQuoteId;
  const QuoteState({
    this.coupleNames = '',
    this.date,
    this.location,
    this.guestCount,
    this.hours = 2,
    this.sessions = const [],
    this.discountCode,
    this.discountPercentage = 0.0,
    this.currentQuoteId,
  });

  QuoteState copyWith({
    String? coupleNames,
    DateTime? date,
    String? location,
    int? guestCount,
    int? hours,
    List<AdditionalSession>? sessions,
    String? discountCode,
    double? discountPercentage,
    String? currentQuoteId,
  }) {
    return QuoteState(
      coupleNames: coupleNames ?? this.coupleNames,
      date: date ?? this.date,
      location: location ?? this.location,
      guestCount: guestCount ?? this.guestCount,
      hours: hours ?? this.hours,
      sessions: sessions ?? this.sessions,
      discountCode: discountCode ?? this.discountCode,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      currentQuoteId: currentQuoteId ?? this.currentQuoteId,
    );
  }
}

class QuoteNotifier extends StateNotifier<QuoteState> {
  QuoteNotifier() : super(const QuoteState());

  static const Map<String, int> locationCosts = {
    'Tuxtla': 0,
    'San Cristóbal': 2000,
    'Comitán': 6000,
    'Palenque': 12500,
    'Puerto Arista': 5500,
  };

  static const Map<String, int> sessionBaseCosts = {
    'preBoda': 2200,
    'postBoda': 2200,
    'studio': 2200,
  };

  static const Map<String, double> discountCodes = {
    'DESCUENTO10': 0.10,
    'DESCUENTO15': 0.15,
    'ANAYACORZOBODAS5': 0.05,
    'ANAYACORZOBODAS10': 0.10,
    'ANAYACORZOBODAS20': 0.20,
  };

  static const Map<int, double> adjustmentsByMonth = {
    0: 0.0,
    1: 0.0,
    2: 0.0,
    3: 0.0,
    4: 0.0,
    5: 0.0,
    6: 0.0,
    7: 0.0,
    8: 0.0,
    9: 0.0,
    10: 0.0,
    11: 0.0,
  };

  void setCoupleNames(String value) {
    state = state.copyWith(coupleNames: value);
  }

  void setDate(DateTime? value) {
    state = state.copyWith(date: value);
  }

  void setLocation(String? value) {
    state = state.copyWith(location: value);
  }

  void setGuestCount(int? value) {
    state = state.copyWith(guestCount: value);
  }

  void setHours(int value) {
    final h = value < 2 ? 2 : (value > 10 ? 10 : value);
    state = state.copyWith(hours: h);
  }

  void toggleSession(String type, {String? location, DateTime? date}) {
    final exists = state.sessions.any((s) => s.type == type);
    if (exists) {
      final updated = state.sessions.where((s) => s.type != type).toList();
      state = state.copyWith(sessions: updated);
    } else {
      final updated = [...state.sessions, AdditionalSession(type: type, location: location, date: date)];
      state = state.copyWith(sessions: updated);
    }
  }

  void setSessionLocation(String type, String? location) {
    final updated = state.sessions
        .map((s) => s.type == type ? AdditionalSession(type: s.type, location: location, date: s.date) : s)
        .toList();
    state = state.copyWith(sessions: updated);
  }

  void setDiscountCode(String? code) {
    final percentage = code != null && discountCodes.containsKey(code) ? discountCodes[code]! : 0.0;
    state = state.copyWith(discountCode: code, discountPercentage: percentage);
  }

  int get imagesCount => state.hours * 65;

  int get baseCost => 2800 + (state.hours > 2 ? (state.hours - 2) * 1200 : 0);

  int get weddingLocationCost {
    final loc = state.location;
    if (loc == null) return 0;
    return locationCosts[loc] ?? 0;
  }

  int get sessionsCost {
    int total = 0;
    for (final s in state.sessions) {
      final base = sessionBaseCosts[s.type] ?? 0;
      final locCost = s.type == 'studio' ? 0 : (s.location != null ? (locationCosts[s.location!] ?? 0) : 0);
      total += base + locCost;
    }
    return total;
  }

  double get adjustmentPercentage {
    final d = state.date;
    if (d == null) return 0.0;
    return adjustmentsByMonth[d.month - 1] ?? 0.0;
  }

  double get totalBeforeAdjustment => (baseCost + weddingLocationCost + sessionsCost).toDouble();

  double get adjustedTotalCost => totalBeforeAdjustment * (1 + adjustmentPercentage);

  double get finalCost => adjustedTotalCost * (1 - state.discountPercentage);

  double get deposit => finalCost * 0.30;
}

final quoteProvider = StateNotifierProvider<QuoteNotifier, QuoteState>((ref) => QuoteNotifier());
