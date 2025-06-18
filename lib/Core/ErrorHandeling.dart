 import 'package:supabase_flutter/supabase_flutter.dart';

String getAuthErrorMessage(AuthException e) {
    switch (e.statusCode) {
      case '400':
        return 'Invalid email or password format';
      case '422':
        return 'Email already in use';
      case '500':
        return 'Server error, please try again later';
      default:
        return e.message;
    }
  }