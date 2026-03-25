import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();

  /// Check if device is currently connected to internet
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result is List) {
        return (result as List).any((r) => r != ConnectivityResult.none);
      }
      return result != ConnectivityResult.none;
    } catch (_) {
      // If connectivity check fails, assume connected and let API handle errors
      return true;
    }
  }

  /// Get stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      if (result is List) {
        return (result as List).any((r) => r != ConnectivityResult.none);
      }
      return result != ConnectivityResult.none;
    });
  }
}
