import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/assertions.dart';

class SaltDatadog {
  static const MethodChannel _channel = const MethodChannel('salt_datadog');

  static Future<bool> init() async {
    final bool version = await _channel.invokeMethod('init');
    return version;
  }

  static void logError(FlutterErrorDetails flutterErrorDetails) async {
    // addError(<message>, <source>, <throwable>, <attributes>)
    await _channel.invokeMethod('addError', {
      'message': flutterErrorDetails.exception.toString(),
    });
  }

  static void startView({String viewKey}) async {
    await _channel.invokeMethod('startView', {
      'viewKey': viewKey,
    });
  }

  static void stopView({String viewKey}) async {
    await _channel.invokeMethod('stopView', {
      'viewKey': viewKey,
    });
  }

  static void mockLogError(String messasge) async {
    // addError(<message>, <source>, <throwable>, <attributes>)
    await _channel.invokeMethod('addError', {
      'message': messasge,
    });
  }
}
