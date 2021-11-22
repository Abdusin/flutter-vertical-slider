import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vertical_slider/flutter_vertical_slider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var value = 50.0;
  void onChanged(double _value) => setState(() => value = _value);
  var value2 = 40.0;
  void onChanged2(double _value) => setState(() => value2 = _value);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(height: 20),
        Row(children: [
          Spacer(),
          Container(
            height: 230,
            child: VerticalSlider(
              onChanged: onChanged,
              max: 100,
              min: 0,
              value: value,
              width: 80,
            ),
          ),
          Spacer(),
          Container(
            height: 230,
            child: VerticalSlider(
              onChanged: onChanged2,
              max: 100,
              min: 0,
              value: value2,
              width: 80,
              activeTrackColor: Colors.amber,
              inactiveTrackColor: Colors.amberAccent.withOpacity(0.5),
            ),
          ),
          Spacer(),
        ]),
      ]),
    );
  }
}
