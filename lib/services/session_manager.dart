import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionManager {
  static Timer? _timer;

  static void startTimer(Function onTimeout) {
    _timer?.cancel();
    _timer = Timer(const Duration(minutes: 30), () async {
      await Supabase.instance.client.auth.signOut();
      onTimeout();
    });
  }

  static void resetTimer(Function onTimeout) {
    startTimer(onTimeout);
  }
}