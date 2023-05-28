import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref();

  Stream getTemperatureStream() {
    return _databaseReference.child('test/temperature').onChildAdded;
  }

  Stream getHumidityStream() {
    return _databaseReference.child('test/humidity').onChildAdded;
  }

}
