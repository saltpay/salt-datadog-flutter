import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salt_datadog/salt_datadog.dart';

void main() {
  FlutterError.onError = (errorDetails) async {
    print(errorDetails.exceptionAsString());
    print(errorDetails.stack);
    await SaltDatadog.logError(errorDetails);
  };

  runZoned(() {
    runApp(MyApp());
  }, onError: (e, stackTrace) {
    print('[$e] [$stackTrace]');
  });
}

final NavigatorObserver navigatorObserver = new NavigatorObserver();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class DatadogNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    // SaltDatadog.stopView(viewKey: previousRoute?.settings?.name);
    // SaltDatadog.startView(viewKey: route?.settings?.name);
    // log('didPush route=${route?.settings?.name} previousRoute=${previousRoute?.settings?.name}');
  }
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  int viewNumber = 0;
  bool viewStarted = false;

  @override
  void dispose() {
    print('dispose');
    // SaltDatadog.stopView(viewKey: '/home');
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      final result = await SaltDatadog.init();
      print('init: ${result.toString()}');
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  random(List<dynamic> list) {
    return (list..shuffle()).first;
  }

  @override
  Widget build(BuildContext context) {
    final now = () => DateTime.now().toIso8601String();
    return MaterialApp(
      // navigatorObservers: [DatadogNavigatorObserver()],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Datadog demo application'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
                  await SaltDatadog.log(
                    'I am a log message from view $viewNumber at ${now()}',
                  );
                },
                child: Text('Log a message'),
              ),
              RaisedButton(
                onPressed: () async {
                  await SaltDatadog.logErrorMessage(
                    'I am an error log message from view $viewNumber at ${now()}',
                  );
                },
                child: Text('Log error message'),
              ),
              RaisedButton(
                onPressed: () {
                  throw Exception('I am a dummy exception');
                  // FlutterError.reportError(
                  //   FlutterErrorDetails(
                  //     exception: SocketException('This is a socket exception'),
                  //     library: 'main.dart',
                  //     context: ErrorSummary('Artificial error'),
                  //   ),
                  // );
                },
                child: Text('Throw an error'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text('Page2'),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Page2(),
            ),
          );
        },
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('Page2'),
      ),
    );
  }
}
