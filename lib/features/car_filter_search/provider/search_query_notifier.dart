import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchQueryNotifier extends Notifier<String> {
  Timer? _timer;

  @override
  String build() {
    ref.onDispose(() => _timer?.cancel());
    return '';
  }

  // Debounce: wait 400ms after the last keystroke
  void onChanged(String text) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 400), () {
      state = text;
    });
  }

  void clear() {
    _timer?.cancel();
    state = '';
  }
}

final searchQueryProvider =
NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);