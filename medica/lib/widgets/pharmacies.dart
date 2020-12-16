import 'package:flutter/material.dart';
import 'package:medica/models/pharmacy.dart';

class PharmaciesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
          itemBuilder: (ctx, index) {
            return Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(5.0),
                    child: Text(
                      "Name: " + PharmacyModel.pharmaciesData[index].name,
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(5.0),
                      child: Text(
                        "Phone: " + PharmacyModel.pharmaciesData[index].phone,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(5.0),
                      child: Text(
                        "Address: " +
                            PharmacyModel.pharmaciesData[index].address,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(5.0),
                      child: RaisedButton(
                        color: Colors.blue[200],
                        child: Icon(Icons.chat),
                        onPressed: () {},
                      )),
                ],
              ),
            ));
          },
          itemCount: PharmacyModel.pharmaciesData.length),
    );
  }
}
