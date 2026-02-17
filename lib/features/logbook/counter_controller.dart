class HistoryEntry {
  final String text;
  final String type; // 'add', 'subtract', 'reset'
  HistoryEntry(this.text, this.type);
}

class CounterController {
  int _counter = 0; //Variabel counter privat
  int _step = 1; //Variabel step privat
  final List<HistoryEntry> _history =
      []; //List untuk menyimpan riwayat nilai counter
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

  // Mengatur nilai step berdasarkan input pengguna
  void setStep(String inputText) {
    int? parsedStep = int.tryParse(inputText);

    if (parsedStep != null && parsedStep >= 1) {
      _step = parsedStep;
    }
  }

  // counter bertambah sebesar step
  void increment() {
    _counter = _counter + _step;
    final now = DateTime.now();
    final timeStr = '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';
    final entry = HistoryEntry(
      'User menambah nilai sebesar $_step pada jam $timeStr',
      'add',
    );
    _history.insert(0, entry);
  }

  void decrement() {
    _counter = _counter - _step;
    final now = DateTime.now();
    final timeStr = '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';
    final entry = HistoryEntry(
      'User mengurangi nilai sebesar $_step pada jam $timeStr',
      'subtract',
    );
    _history.insert(0, entry);
  }

  void reset() {
    _counter = 0;
    final now = DateTime.now();
    final timeStr = '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';
    final entry = HistoryEntry('User mereset nilai pada jam $timeStr', 'reset');
    _history.insert(0, entry);
  }
}
