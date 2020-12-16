import 'package:firebase_database/firebase_database.dart';
import 'auth.dart';

class Hospitlal {
  final String name;
  final String address;
  final String phone;

  Hospitlal(this.name, this.address, this.phone);
}

class HospitalData {
  static List<Hospitlal> hospitalData = [];

  static Future<bool> fetchHospitals() async {
    try {
      await Auth.database
          .child('hospitals/ismailia')
          .once()
          .then((DataSnapshot snapshot) {
        var data = snapshot.value;
        for (var hospital in data) {
          hospitalData.add(Hospitlal(
              hospital['name'], hospital['address'], hospital['phone']));
        }
      });
    } catch (error) {
      print(error.toString());
    }
    return true;
  }
}
