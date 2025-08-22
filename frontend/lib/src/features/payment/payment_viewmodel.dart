import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';

class PaymentViewModel extends ChangeNotifier {
  final ApiClient api;
  PaymentViewModel(this.api);

  bool paying = false;
  bool success = false;
  String? error;

  Future<void> pay() async {
    paying = true;
    success = false;
    error = null;
    notifyListeners();
    // Mock payment delay
    await Future.delayed(const Duration(seconds: 2));
    success = true;
    paying = false;
    notifyListeners();
  }
}
