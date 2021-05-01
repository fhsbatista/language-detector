import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_detector/modules/core/platform/network_info_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockConnectivity connectivity;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    connectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(connectivity);
  });

  group('isConnected', () {
    test('should forward the call to the connectivity api', () async {
      //arrange
      final isConnected = true;
      when(() => connectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.mobile);

      //act
      final result = await networkInfo.isConnected;

      //assert
      verify(() => connectivity.checkConnectivity());
      expect(result, isConnected);
    });
  });
}
