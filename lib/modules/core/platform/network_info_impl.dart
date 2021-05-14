import 'package:connectivity/connectivity.dart';
import 'package:language_detector/modules/core/platform/network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    return await connectivity.checkConnectivity() != ConnectivityResult.none;
  }
}
