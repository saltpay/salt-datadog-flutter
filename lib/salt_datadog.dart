import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SaltDatadog {
  static const MethodChannel _channel = const MethodChannel('salt_datadog');

  static Future<bool> init() async {
    final bool version = await _channel.invokeMethod('init');
    return version;
  }

  static Future<void> startView({
    @required String viewName,
    String viewKey,
    Map attributes,
  }) async {
    await _channel.invokeMethod('startView', {
      'viewKey': viewKey ?? '',
      'viewName': viewName ?? '',
      'attributes': attributes ?? Map<String, String>(),
    });
  }

  static Future<void> stopView({
    String viewKey,
    Map attributes,
  }) async {
    await _channel.invokeMethod('stopView', {
      'viewKey': viewKey ?? '',
      'attributes': attributes ?? Map<String, String>(),
    });
  }

  static Future<void> addUserAction({
    @required String name,
    Map attributes,
  }) async {
    await _channel.invokeMethod('addUserAction', {
      'name': name ?? '',
      'attributes': attributes ?? Map<String, String>(),
    });
  }

  static Future<void> startUserAction({
    @required String name,
    Map attributes,
  }) async {
    await _channel.invokeMethod('startUserAction', {
      'name': name ?? '',
      'attributes': attributes ?? Map<String, String>(),
    });
  }

  static Future<void> stopUserAction({
    @required String name,
    Map attributes,
  }) async {
    await _channel.invokeMethod('stopUserAction', {
      'name': name ?? '',
      'attributes': attributes ?? Map<String, String>(),
    });
  }

  static Future<void> startResource({
    @required String method,
    @required String url,
    String key,
    Map attributes,
  }) async {
    await _channel.invokeMethod('startResource', {
      'key': key ?? '',
      'method': method ?? '',
      'url': url ?? '',
      'attributes': attributes ?? Map<String, String>(),
    });
  }

  static Future<void> stopResource({
    int statusCode,
    int size,
    String key,
    Map attributes,
  }) async {
    await _channel.invokeMethod('stopResource', {
      'key': key ?? '',
      'statusCode': statusCode ?? 0,
      'size': size ?? 0,
      'attributes': attributes ?? Map<String, String>(),
    });
  }

  static Future<void> logErrorMessage(
    String messasge, {
    Map attributes,
  }) async {
    await _channel.invokeMethod('addError', {
      'message': messasge,
      'attributes': attributes ?? Map<String, String>(),
    });
  }

  static Future<void> logError(
    FlutterErrorDetails flutterErrorDetails, {
    Map attributes,
  }) async {
    await _channel.invokeMethod('addError', {
      'message': flutterErrorDetails.exception.toString(),
      'attributes': attributes ?? Map<String, String>(),
    });
  }
}
