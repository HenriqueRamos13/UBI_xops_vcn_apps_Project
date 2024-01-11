import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  ConnectivityService() {
    // Inicie a verificação de conectividade
    _checkConnectivity();
    // Configure um listener para mudanças na conectividade
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    bool newIsConnected = (connectivityResult != ConnectivityResult.none);
    if (_isConnected != newIsConnected) {
      _isConnected = newIsConnected;
      notifyListeners();
    }
  }
}
