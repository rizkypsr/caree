import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  late StreamSubscription<ConnectivityResult> _subscription;
  late StreamController<ConnectivityResult> _networkStatusController;

  ConnectivityService() {
    _networkStatusController = StreamController<ConnectivityResult>();
    _invokeNetwokStatusListen();
  }

  StreamSubscription<ConnectivityResult> get subscription => _subscription;
  StreamController<ConnectivityResult> get networkStatusController =>
      _networkStatusController;

  _invokeNetwokStatusListen() async {
    _networkStatusController.sink.add(await Connectivity().checkConnectivity());
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      _networkStatusController.sink.add(result);
    });
  }

  disposeStreams() {
    _subscription.cancel();
    _networkStatusController.close();
  }
}
