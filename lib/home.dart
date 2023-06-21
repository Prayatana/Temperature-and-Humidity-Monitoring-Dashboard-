import 'dart:developer';

import 'package:iot/onboarding.dart';
import 'package:iot/service.dart';
import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';

import 'pushNotification.dart';

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
    PushNotification.initialize();
  }

  void _subscribeToTemperatureStream() {
    _firebaseService.getTemperatureStream().listen((event) {
      setState(() {
        double temperature = double.parse(event.snapshot.value.toString());
        temperatureDataList.add(
          TemperatureData(
            DateTime.now(),
            temperature,
          ),
        );
        PushNotification.checkTemperature(temperature);
      });
    });
  }

  void _subscribeToHumidityStream() {
    _firebaseService.getHumidityStream().listen((event) {
      setState(() {
        double humidity = double.parse(event.snapshot.value.toString());
        humidityDataList.add(
          HumidityData(
            DateTime.now(),
            humidity,
          ),
        );
        PushNotification.checkHumidity(humidity);
      });
    });
  }

  // List<charts.Series<TemperatureData, DateTime>> _createTemperatureSeriesData() {
  //   return [
  //     charts.Series<TemperatureData, DateTime>(
  //       id: 'Temperature',
  //       colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
  //       domainFn: (TemperatureData data, _) => data.time,
  //       measureFn: (TemperatureData data, _) => data.temperature,
  //       data: temperatureDataList,
  //     ),
  //   ];
  // }

  // List<charts.Series<HumidityData, DateTime>> _createHumiditySeriesData() {
  //   return [
  //     charts.Series<HumidityData, DateTime>(
  //       id: 'Humidity',
  //       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //       domainFn: (HumidityData data, _) => data.time,
  //       measureFn: (HumidityData data, _) => data.humidity,
  //       data: humidityDataList,
  //     ),
  //   ];
  // }

  // List<charts.Series<TemperatureData, DateTime>>
  //     _createTemperatureSeriesData() {
  //   return <charts.Series<TemperatureData, DateTime>>[
  //     charts.Series<TemperatureData, DateTime>(
  //       id: 'Temperature',
  //       color: charts.MaterialPalette.red.shadeDefault,
  //       domainFn: (TemperatureData data, _) => data.time,
  //       measureFn: (TemperatureData data, _) => data.temperature,
  //       data: temperatureDataList,
  //     ),
  //   ];
  // }

  // List<charts.Series<HumidityData, DateTime>> _createHumiditySeriesData() {
  //   return <charts.Series<HumidityData, DateTime>>[
  //     charts.Series<HumidityData, DateTime>(
  //       id: 'Humidity',
  //       color: charts.MaterialPalette.blue.shadeDefault,
  //       domainFn: (HumidityData data, _) => data.time,
  //       measureFn: (HumidityData data, _) => data.humidity,
  //       data: humidityDataList,
  //     ),
  //   ];
  // }

  List<SplineSeries<TemperatureData, DateTime>> _createTemperatureSeriesData() {
    return <SplineSeries<TemperatureData, DateTime>>[
      SplineSeries<TemperatureData, DateTime>(
        dataSource: temperatureDataList,
        xValueMapper: (TemperatureData data, _) => data.time,
        yValueMapper: (TemperatureData data, _) => data.temperature,
      ),
    ];
  }

  List<SplineSeries<HumidityData, DateTime>> _createHumiditySeriesData() {
    return <SplineSeries<HumidityData, DateTime>>[
      SplineSeries<HumidityData, DateTime>(
        dataSource: humidityDataList,
        xValueMapper: (HumidityData data, _) => data.time,
        yValueMapper: (HumidityData data, _) => data.humidity,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: SfCartesianChart(
                  series: _createTemperatureSeriesData(),
                  primaryXAxis: DateTimeAxis(),
                  primaryYAxis: NumericAxis(),
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
                child: SfCartesianChart(
                  series: _createHumiditySeriesData(),
                  primaryXAxis: DateTimeAxis(),
                  primaryYAxis: NumericAxis(),
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
