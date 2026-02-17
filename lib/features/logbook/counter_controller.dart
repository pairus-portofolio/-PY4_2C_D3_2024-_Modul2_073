import 'package:shared_preferences/shared_preferences.dart';

class HistoryEntry {
  final String text;
  final String type; // 'add', 'subtract', 'reset'
  HistoryEntry(this.text, this.type);
}

class CounterController {
  int _counter = 0; //Variabel counter privat
  int _step = 1; //Variabel step privat

  final List<HistoryEntry> _history = [];
  //List untuk menyimpan riwayat nilai counter
  // Simpan riwayat ke SharedPreferences
  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = _history.map((e) => '${e.text}|${e.type}').toList();
    await prefs.setStringList('history', historyList);
  }

  // Muat riwayat dari SharedPreferences
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = prefs.getStringList('history') ?? [];
    _history.clear();
    for (var item in historyList) {
      final parts = item.split('|');
      if (parts.length == 2) {
        _history.add(HistoryEntry(parts[0], parts[1]));
      }
    }
  }

  String _twoDigits(int n) =>
      n.toString().padLeft(2, '0'); //Fungsi untuk format dua digit

  // Getter untuk mengakses nilai
  int get counter => _counter;
  int get step => _step;
  List<HistoryEntry> get getHistory => _history;
  List<HistoryEntry> get recentHistory {
    final end = _history.length < 5 ? _history.length : 5;
    return _history.sublist(0, end);
  }

  void setCounter(int value) {
    _counter = value;
  }

  // Mengatur nilai step berdasarkan input pengguna
  void setStep(String inputText) {
    int? parsedStep = int.tryParse(inputText);

    if (parsedStep != null && parsedStep >= 1) {
      _step = parsedStep;
    }
  }

  // counter bertambah sebesar step
  Future<void> increment() async {
    _counter = _counter + _step;
    final now = DateTime.now();
    final timeStr = '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';
    final entry = HistoryEntry(
      'User menambah nilai sebesar $_step pada jam $timeStr',
      'add',
    );
    _history.insert(0, entry);
    await saveLastValue(_counter);
    await saveHistory();
  }

  Future<void> decrement() async {
    _counter = _counter - _step;
    final now = DateTime.now();
    final timeStr = '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';
    final entry = HistoryEntry(
      'User mengurangi nilai sebesar $_step pada jam $timeStr',
      'subtract',
    );
    _history.insert(0, entry);
    await saveLastValue(_counter);
    await saveHistory();
  }

  Future<void> reset() async {
    _counter = 0;
    final now = DateTime.now();
    final timeStr = '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';
    final entry = HistoryEntry('User mereset nilai pada jam $timeStr', 'reset');
    _history.insert(0, entry);
    await saveLastValue(_counter);
    await saveHistory();
  }

  Future<void> saveLastValue(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_counter', value);
  }

  Future<int> loadLastValue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('last_counter') ?? 0;
  }
}
