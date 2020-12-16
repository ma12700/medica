import 'dart:convert';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:medica/models/auth.dart';
import '../models/http_exception.dart';

class Pharmacy {
  final String name;
  final String phone;
  final String address;

  Pharmacy(
    this.name,
    this.phone,
    this.address,
  );
}

class PharmacyModel {
  static List<Pharmacy> pharmaciesData = [];
  static Future<bool> fetchpharmacies() async {
    try {
      await Auth.database
          .child('pharmacies')
          .once()
          .then((DataSnapshot snapshot) {
        var data = snapshot.value;
        for (var id in data.keys) {
          pharmaciesData.add(Pharmacy(
              data[id]['name'], data[id]['phone'], data[id]['address']));
        }
      });
    } catch (error) {
      print(error.toString());
    }
    return true;
  }

  static Future<void> addPharmacy(
      String email, String password, Pharmacy pharmacy) async {
    var url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyAo7iwfEDg9xbSlrCHmQOZhHhcHswzjG7U';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      var userId = responseData['localId'];

      await Auth.database.child('users/$userId').update({
        'type': 'pharmacy',
      });
      await Auth.database.child('pharmacies/$userId').update({
        'name': pharmacy.name,
        'address': pharmacy.address,
        'phone': pharmacy.phone,
      });
    } catch (error) {
      print(error.toString());
    }
  }
}
