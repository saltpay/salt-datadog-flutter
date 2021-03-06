import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:salt_datadog/priority.dart';
export 'priority.dart';

class SaltDatadog {
  static const MethodChannel _channel = const MethodChannel('salt_datadog');

  static Future<bool> init({
    @required String clientToken,
    @required String environment,
    @required String applicationId,
    @required String senderId,
  }) async {
    final bool version = await _channel.invokeMethod('init', {
      'clientToken': clientToken,
      'environment': environment,
      'applicationId': applicationId,
      'senderId': senderId,
    });
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

  static Future<void> logError(
    String message, {
    Map attributes,
  }) async {
    await _channel.invokeMethod('addError', {
      'message': message,
      'attributes': attributes ?? Map<String, String>(),
    });
  }

  static Future<void> log(
    String message, {
    Map attributes,
    int priority = Log.DEBUG,
  }) async {
    await _channel.invokeMethod('log', {
      'message': message,
      'priority': priority,
      'attributes': attributes ?? Map<String, String>(),
    });
  }

  static Future<void> addTag(String key, String value) async {
    await _channel.invokeMethod('addTag', {
      'key': key,
      'value': value,
    });
  }

  static Future<void> addAttribute(String key, String value) async {
    await _channel.invokeMethod('addAttribute', {
      'key': key,
      'value': value,
    });
  }
}
