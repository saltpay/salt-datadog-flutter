import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:salt_datadog/salt_datadog.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    final message = errorDetails.toString();
    print(message);
    await SaltDatadog.startView(viewName: 'FLUTTER_ERROR');
    await SaltDatadog.logError(message);
    await SaltDatadog.stopView();
    await SaltDatadog.log(message, priority: Log.ERROR);
  };

  runZoned(() {
    runApp(MyApp());
  }, onError: (e, stackTrace) async {
    final message = 'runZoned onError(): exception: [$e], stack: [$stackTrace]';
    print(message);
    await SaltDatadog.log(message, priority: Log.ERROR);
    await SaltDatadog.startView(viewName: 'ZONED_ERROR');
    await SaltDatadog.logError(message);
    await SaltDatadog.stopView();
  });
}

final NavigatorObserver navigatorObserver = new NavigatorObserver();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int viewNumber = 0;
  bool viewStarted = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final result = await SaltDatadog.init(
      clientToken: "pub6de5d25ee61dc1cb99f774e8f935c2ca",
      environment: "development",
      applicationId: "441316d2-4c7b-4317-b3d4-77bb4a66927d",
      senderId: "demo-application",
    );
    print('init datadog: ${result.toString()}');
  }

  random(List<dynamic> list) {
    return (list..shuffle()).first;
  }

  @override
  Widget build(BuildContext context) {
    final now = () => DateTime.now().toIso8601String();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Datadog demo application'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Datadog RUM API', style: TextStyle(fontSize: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      await SaltDatadog.startView(
                        viewName: '/home/$viewNumber',
                      );
                      setState(() {
                        viewNumber += 1;
                        viewStarted = true;
                      });
                    },
                    child: Text('Start view ($viewNumber)'),
                    color: viewStarted ? Colors.red : Color(0xFFCCCCCC),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (viewNumber == 0) {
                        return;
                      }
                      await SaltDatadog.stopView();
                      setState(() {
                        viewStarted = false;
                      });
                    },
                    child: Text('Stop view'),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () async {
                  await SaltDatadog.addUserAction(
                    name: 'custom-user-action-$viewNumber',
                  );
                },
                child: Text('Add user action ($viewNumber)'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      await SaltDatadog.startUserAction(
                        name: 'user-action-$viewNumber',
                      );
                    },
                    child: Text('Start user action ($viewNumber)'),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await SaltDatadog.stopUserAction(
                        name: 'user-action-$viewNumber',
                      );
                    },
                    child: Text('Stop user action'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      final methods = ['get', 'post', 'put', 'patch', 'delete'];
                      final urls = [
                        'https://google.com',
                        'https://twitter.com',
                        'https://saltpay.co',
                      ];
                      await SaltDatadog.startResource(
                        method: random(methods),
                        url: random(urls),
                      );
                    },
                    child: Text('Start resource ($viewNumber)'),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      final statusCodes = [404, 201, 500, 400, 200];
                      final statusCode = (statusCodes..shuffle()).first;
                      final size = Random().nextInt(1000);
                      await SaltDatadog.stopResource(
                        statusCode: statusCode,
                        size: size,
                      );
                    },
                    child: Text('Stop resource'),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () async {
                  await SaltDatadog.logError(
                    'I am an error log message from view $viewNumber at ${now()}',
                  );
                },
                child: Text('Log an error'),
              ),
              Text('Datadog logging API', style: TextStyle(fontSize: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      await SaltDatadog.log(
                        'I am a log message from view $viewNumber at ${now()}',
                      );
                    },
                    child: Text('Log a message'),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await SaltDatadog.log(
                          'I am a error log message from view $viewNumber at ${now()}',
                          priority: Log.ERROR
                      );
                    },
                    child: Text('Log an error message'),
                  ),
                ],
              ),
              Text('Generate Flutter errors', style: TextStyle(fontSize: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () {
                      throw Exception('I am a dummy exception');
                    },
                    child: Text('Throw an exception'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      FlutterError.reportError(
                        FlutterErrorDetails(
                          exception: SocketException(
                            'This is a socket exception raised via FlutterError',
                          ),
                          stack: StackTrace.current,
                          context: ErrorSummary('Artificial error'),
                        ),
                      );
                    },
                    child: Text('Throw a FlutterError'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
