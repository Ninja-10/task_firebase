import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  Connectivity _connectivity = Connectivity();

  Future<bool> get isConnected async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
