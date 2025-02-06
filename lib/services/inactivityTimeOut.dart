import 'dart:async';
import 'dart:ui';

class InactivityLogoutManager {
  final Duration timeout;
  Timer? _timer;
  final VoidCallback onLogout;

  InactivityLogoutManager({required this.timeout, required this.onLogout});

  void reset() {
    _timer?.cancel();
    _timer = Timer(timeout, onLogout);
  }

  void dispose() {
    _timer?.cancel();
  }
}
