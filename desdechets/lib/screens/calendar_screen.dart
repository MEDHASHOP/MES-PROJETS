import 'package:flutter/material.dart';
import '../models/index.dart';

/// Classe représentant un jour de calendrier
class CalendarDay {
  final DateTime date;
  final List<WasteCollection> collections;
  final bool isToday;
  final bool isCurrentMonth;

  const CalendarDay({
    required this.date,
    this.collections = const [],
    this.isToday = false,
    this.isCurrentMonth = true,
  });

  /// Obtenir le type de déchet principal du jour
  WasteType? getPrimaryWasteType() {
    if (collections.isEmpty) return null;
    return collections.first.type;
  }

  /// Vérifier si une collecte est prévue
  bool hasCollection() => collections.isNotEmpty;

  /// Créer une copie avec modifications
  CalendarDay copyWith({
    DateTime? date,
    List<WasteCollection>? collections,
    bool? isToday,
    bool? isCurrentMonth,
  }) {
    return CalendarDay(
      date: date ?? this.date,
      collections: collections ?? this.collections,
      isToday: isToday ?? this.isToday,
      isCurrentMonth: isCurrentMonth ?? this.isCurrentMonth,
    );
  }

  @override
  String toString() =>
      'CalendarDay(date: $date, collectionsCount: ${collections.length})';
}

/// Classe représentant l'état du calendrier
class CalendarScreenState {
  final DateTime selectedMonth;
  final List<CalendarDay> days; // Tous les jours du mois
  final List<WasteCollection>
  selectedDayCollections; // Collectes du jour sélectionné
  final DateTime? selectedDate;
  final bool isLoading;
  final String? error;
  final ViewMode viewMode; // Calendrier ou liste

  const CalendarScreenState({
    required this.selectedMonth,
    this.days = const [],
    this.selectedDayCollections = const [],
    this.selectedDate,
    this.isLoading = false,
    this.error,
    this.viewMode = ViewMode.calendar,
  });

  /// Obtenir le nombre de jours du mois
  int get daysInMonth => days.where((d) => d.isCurrentMonth).length;

  /// Obtenir les collectes du mois
  List<WasteCollection> get monthCollections =>
      days.expand((d) => d.collections).toList();

  /// Créer une copie avec modifications
  CalendarScreenState copyWith({
    DateTime? selectedMonth,
    List<CalendarDay>? days,
    List<WasteCollection>? selectedDayCollections,
    DateTime? selectedDate,
    bool? isLoading,
    String? error,
    ViewMode? viewMode,
  }) {
    return CalendarScreenState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      days: days ?? this.days,
      selectedDayCollections:
          selectedDayCollections ?? this.selectedDayCollections,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  @override
  String toString() =>
      'CalendarScreenState(month: $selectedMonth, selectedDate: $selectedDate, viewMode: $viewMode)';
}

/// Mode d'affichage du calendrier
enum ViewMode {
  calendar, // Vue calendrier
  list, // Vue liste
  week, // Vue semaine
}

/// Classe pour un événement de collecte
class CollectionEvent {
  final String id;
  final DateTime date;
  final WasteType type;
  final String? location;
  final TimeOfDay? time;
  final bool isRecurring; // Si l'événement se répète
  final RecurrencePattern? recurrence;

  const CollectionEvent({
    required this.id,
    required this.date,
    required this.type,
    this.location,
    this.time,
    this.isRecurring = false,
    this.recurrence,
  });

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type.toString(),
      'location': location,
      'time': time?.toString(),
      'isRecurring': isRecurring,
      'recurrence': recurrence?.toJson(),
    };
  }

  /// Créer depuis JSON
  factory CollectionEvent.fromJson(Map<String, dynamic> json) {
    return CollectionEvent(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      type: WasteType.values.firstWhere(
        (type) => type.toString() == json['type'],
        orElse: () => WasteType.mixed,
      ),
      location: json['location'] as String?,
      time: json['time'] != null ? _parseTimeOfDay(json['time']) : null,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurrence: json['recurrence'] != null
          ? RecurrencePattern.fromJson(json['recurrence'])
          : null,
    );
  }

  @override
  String toString() =>
      'CollectionEvent(id: $id, date: $date, type: ${type.displayName})';
}

/// Classe pour la récurrence des événements
class RecurrencePattern {
  final RecurrenceType type;
  final int? interval; // Tous les N jours/semaines/mois
  final List<int>? daysOfWeek; // Pour les semaines (0=lundi, 6=dimanche)
  final DateTime? endDate; // Date de fin de récurrence
  final int? occurrences; // Nombre d'occurrences

  const RecurrencePattern({
    required this.type,
    this.interval,
    this.daysOfWeek,
    this.endDate,
    this.occurrences,
  });

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'interval': interval,
      'daysOfWeek': daysOfWeek,
      'endDate': endDate?.toIso8601String(),
      'occurrences': occurrences,
    };
  }

  /// Créer depuis JSON
  factory RecurrencePattern.fromJson(Map<String, dynamic> json) {
    return RecurrencePattern(
      type: RecurrenceType.values.firstWhere(
        (type) => type.toString() == json['type'],
        orElse: () => RecurrenceType.none,
      ),
      interval: json['interval'] as int?,
      daysOfWeek: List<int>.from(json['daysOfWeek'] as List? ?? []),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      occurrences: json['occurrences'] as int?,
    );
  }

  @override
  String toString() => 'RecurrencePattern(type: $type, interval: $interval)';
}

/// Types de récurrence
enum RecurrenceType { none, daily, weekly, biweekly, monthly, yearly }

/// Fonction utilitaire pour parser TimeOfDay depuis string
TimeOfDay _parseTimeOfDay(String timeString) {
  final parts = timeString.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}
