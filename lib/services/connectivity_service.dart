import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();

  /// Check if device is currently connected to internet
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (_) {
      return false;
    }
  }

  /// Get stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }

  /// Check specific connection type
  Future<ConnectivityResult?> getConnectionType() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none ? result : null;
    } catch (_) {
      return null;
    }
  }
}
