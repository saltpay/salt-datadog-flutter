import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salt_datadog/salt_datadog.dart';

void main() {
  FlutterError.onError = (errorDetails) {
    SaltDatadog.logError(errorDetails);
  };

  runApp(MyApp());
}

final NavigatorObserver navigatorObserver = new NavigatorObserver();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class DatadogNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    SaltDatadog.stopView(viewKey: previousRoute?.settings?.name);
    SaltDatadog.startView(viewKey: route?.settings?.name);
    log('didPush route=${route?.settings?.name} previousRoute=${previousRoute?.settings?.name}');
  }
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void dispose() {
    print('dispose');
    SaltDatadog.stopView(viewKey: '/home');
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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final result = await SaltDatadog.init();
      print(result.toString());

      SaltDatadog.mockLogError('OMG');
      SaltDatadog.startView(viewKey: '/home');
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [DatadogNavigatorObserver()],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Page1(),
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
