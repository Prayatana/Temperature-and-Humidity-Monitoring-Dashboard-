// Awesome notification 
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class PushNotification {
  static void initialize() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'high_humidity',
          channelName: 'High Humidity',
          channelDescription: 'Notification channel for high humidity',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          playSound: true,
          enableLights: true,
          enableVibration: true,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: 'high_temperature',
          channelName: 'High Temperature',
          channelDescription: 'Notification channel for high temperature',
          defaultColor: Color(0xFFE67E22),
          ledColor: Colors.white,
          playSound: true,
          enableLights: true,
          enableVibration: true,
          importance: NotificationImportance.High,
        ),
      ],
    );
  }

  static void checkHumidity(double humidity) {
    if (humidity > 50) {
      _showHighHumidityNotification();
    }
  }

  static void checkTemperature(double temperature) {
    if (temperature > 50) {
      _showHighTemperatureNotification();
    }
  }

  static void _showHighHumidityNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'high_humidity',
        title: 'High Humidity Alert',
        body: 'The humidity level has risen above 50.',
        wakeUpScreen: true,
      ),
    );
  }

  static void _showHighTemperatureNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'high_temperature',
        title: 'High Temperature Alert',
        body: 'The temperature has risen above 40.',
      ),
    );
  }
}
