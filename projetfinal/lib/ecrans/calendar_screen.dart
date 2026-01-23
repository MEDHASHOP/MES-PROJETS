import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../data/donnees_test.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Map<String, dynamic>>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();

    // Générer des événements aléatoires pour les prochains jours
    _generateRandomEvents();
  }

  /// Génère des événements de collecte aléatoires pour les 30 prochains jours
  void _generateRandomEvents() {
    _events = {};
    final startDate = DateTime.now().add(const Duration(days: 1));

    // Ajouter des événements pour les 30 prochains jours
    for (int i = 0; i < 30; i++) {
      final day = DateTime(startDate.year, startDate.month, startDate.day + i);

      // 30% de chance d'avoir une collecte ce jour-là
      if (_shouldCreateEvent(i)) {
        final hour = _getRandomHour();
        final wasteType = _getRandomWasteType();
        final location = _getRandomLocation();

        final collection = {
          'id': 'collecte_${day.year}${day.month}${day.day}_$i',
          'date': DateTime(day.year, day.month, day.day, hour),
          'typeDechets': wasteType,
          'lieu': location,
          'utilisateur': utilisateursTest[0], // Utilisateur par défaut
        };

        _events[DateTime(day.year, day.month, day.day)] = [collection];
      }
    }
  }

  /// Détermine si un événement doit être créé (30% de probabilité)
  bool _shouldCreateEvent(int dayIndex) {
    return DateTime.now().millisecondsSinceEpoch % (dayIndex + 10) < 3000000000;
  }

  /// Génère une heure aléatoire entre 8h et 15h
  int _getRandomHour() {
    return 8 + (DateTime.now().millisecondsSinceEpoch % 7);
  }

  /// Sélectionne un type de déchet aléatoire
  String _getRandomWasteType() {
    const types = ['plastique', 'papier', 'verre', 'organique'];
    return types[DateTime.now().millisecondsSinceEpoch % types.length];
  }

  /// Sélectionne un point de collecte aléatoire
  dynamic _getRandomLocation() {
    return pointsCollecteTest[DateTime.now().millisecondsSinceEpoch % pointsCollecteTest.length];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text('Calendrier des collectes'),
          ],
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2027, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) => _events[day] ?? [],
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.green[200],
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green[700],
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _selectedDayEvents(),
          ),
        ],
      ),
    );
  }

  /// Affiche les événements du jour sélectionné
  Widget _selectedDayEvents() {
    final dayEvents = _events[_selectedDay] ?? [];

    if (dayEvents.isEmpty) {
      return const Center(
        child: Text(
          'Aucune collecte prévue ce jour',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: dayEvents.length,
      itemBuilder: (context, index) {
        final event = dayEvents[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                '${event['date'].hour}h',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text('Collecte de ${event['typeDechets']}'),
            subtitle: Text('Lieu: ${event['lieu'].nom}'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        );
      },
    );
  }
}