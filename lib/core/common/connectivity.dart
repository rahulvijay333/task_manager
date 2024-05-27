import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // Create a singleton instance of the ConnectivityService
  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() {
    return _instance;
  }

  // Private constructor to prevent direct instantiation
  ConnectivityService._internal();

  final Connectivity connectivity = Connectivity();

  Future<bool> checkIntilialConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await (connectivity.checkConnectivity());

// This condition is for demo purposes only to explain every connection type.
// Use conditions which work for your requirements.
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.

      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      return false;
    }
  }
}
