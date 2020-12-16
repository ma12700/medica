import 'dart:convert';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:medica/models/auth.dart';
import '../models/http_exception.dart';

class Doctor {
  final String specialty;
  final String name;
  final String phone;
  final String address;
  final int rate;

  Doctor(this.specialty, this.name, this.phone, this.address, this.rate);
}

class DoctorModel {
  static List<Doctor> doctorsData = [];
  static int topRate = 1;
  static Future<bool> fetchDoctors(String specialty) async {
    try {
      await Auth.database
          .child('specialty/$specialty/doctors')
          .once()
          .then((DataSnapshot snapshot) {
        var data = snapshot.value;
        doctorsData = [];
        topRate = 1;
        for (var id in data.keys) {
          doctorsData.add(Doctor(specialty, data[id]['name'], data[id]['phone'],
              data[id]['address'], data[id]['rate']));
          if (topRate < data[id]['rate']) {
            topRate = data[id]['rate'];
          }
        }
        doctorsData.sort((a, b) {
          if (a.rate >= b.rate) {
            return 1;
          }
          return -1;
        });
      });
    } catch (error) {
      print(error.toString());
    }
    return true;
  }

  static Future<void> addDoctor(
      String email, String password, Doctor doctor) async {
    var url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyAo7iwfEDg9xbSlrCHmQOZhHhcHswzjG7U';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      var userId = responseData['localId'];
      await Auth.database.child('users/$userId').update({
        'type': 'patient',
      });
      await Auth.database
          .child('specialty/${doctor.specialty}/doctors/$userId')
          .update({
        'name': doctor.name,
        'address': doctor.address,
        'phone': doctor.phone,
        'rate': 1
      });
    } catch (error) {
      print(error.toString());
    }
  }
}
