import 'package:iot/service.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class RealTimeDataPage extends StatefulWidget {
  @override
  _RealTimeDataPageState createState() => _RealTimeDataPageState();
}

class _RealTimeDataPageState extends State<RealTimeDataPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<TemperatureData> temperatureDataList = [];
  List<HumidityData> humidityDataList = [];

  @override
  void initState() {
    super.initState();
    _subscribeToTemperatureStream();
    _subscribeToHumidityStream();
  }

  void _subscribeToTemperatureStream() {
    _firebaseService.getTemperatureStream().listen((event) {
      setState(() {
        temperatureDataList.add(
          TemperatureData(
            DateTime.now(),
            double.parse(event.snapshot.value.toString()),
          ),
        );
      });
    });
  }

  void _subscribeToHumidityStream() {
    _firebaseService.getHumidityStream().listen((event) {
      setState(() {
        humidityDataList.add(
          HumidityData(
            DateTime.now(),
            double.parse(event.snapshot.value.toString()),
          ),
        );
      });
    });
  }

  




  List<charts.Series<TemperatureData, DateTime>> _createTemperatureSeriesData() {
    return [
      charts.Series<TemperatureData, DateTime>(
        id: 'Temperature',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TemperatureData data, _) => data.time,
        measureFn: (TemperatureData data, _) => data.temperature,
        data: temperatureDataList,
      ),
    ];
  }

  List<charts.Series<HumidityData, DateTime>> _createHumiditySeriesData() {
    return [
      charts.Series<HumidityData, DateTime>(
        id: 'Humidity',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (HumidityData data, _) => data.time,
        measureFn: (HumidityData data, _) => data.humidity,
        data: humidityDataList,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(
      //   title: Text('Temperature & Humidity Tracking'),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                'Temperature',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 275,
                child: charts.TimeSeriesChart(
                  _createTemperatureSeriesData(),
                  animate: true,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Humidity',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 275,
                child: charts.TimeSeriesChart(
                  _createHumiditySeriesData(),
                  animate: true,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TemperatureData {
  final DateTime time;
  final double temperature;

  TemperatureData(this.time, this.temperature);
}

class HumidityData {
  final DateTime time;
  final double humidity;

  HumidityData(this.time, this.humidity);
}