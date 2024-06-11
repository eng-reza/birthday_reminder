import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(flutterLocalNotificationsPlugin),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  MyHomePage(this.flutterLocalNotificationsPlugin);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();

  void _submitData() async {
    final enteredName = _nameController.text;
    final enteredDate = _dateController.text;

    if (enteredName.isEmpty || enteredDate.isEmpty) {
      return;
    }

    DateTime scheduledDate = DateFormat('yyyy-MM-dd').parse(enteredDate);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'birthday_reminder', 'Birthday Reminder',
        channelDescription: 'Remember to wish happy birthday',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await widget.flutterLocalNotificationsPlugin.schedule(
        0,
        'Birthday Reminder',
        'It\'s $enteredName\'s birthday today!',
        scheduledDate,
        platformChannelSpecifics);

    print('Name: $enteredName, Date: $enteredDate');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Birthday Reminder'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              controller: _nameController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Birthday (YYYY-MM-DD)'),
              controller: _dateController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Add Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
