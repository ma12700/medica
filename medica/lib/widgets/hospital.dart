import 'package:flutter/material.dart';
import 'package:medica/models/hospitals.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: hospitalsList(),
        ));
  }

  Widget hospitalsList() {
    return ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 5,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    _launchMapsUrl(HospitalData.hospitalData[index].name);
                  },
                  child: Image.asset(
                    'assets/images/map.png',
                    width: 50.0,
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          HospitalData.hospitalData[index].name,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          'العنوان: ${HospitalData.hospitalData[index].address}‬',
                        ),
                      ),
                      Container(
                          width: double.infinity,
                          child: Text(
                              'الهاتف: ${HospitalData.hospitalData[index].phone} '))
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: HospitalData.hospitalData.length);
  }

  void _launchMapsUrl(String title) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$title';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
