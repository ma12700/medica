import 'package:flutter/material.dart';
import '../models/doctors.dart';
import '../models/consulting.dart';

class DoctorsWidget extends StatefulWidget {
  _DoctorsWidgetState createState() => _DoctorsWidgetState();
}

class _DoctorsWidgetState extends State<DoctorsWidget> {
  var dropdownValue = ConsultingData.specialties[0];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          selectMenu(),
          Expanded(
            child: FutureBuilder(
                future: DoctorModel.fetchDoctors(dropdownValue),
                builder: (ctx, fetchResultSnapshot) =>
                    fetchResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : doctorsList()),
          ),
        ],
      ),
    );
  }

  Widget selectMenu() {
    return DropdownButton<String>(
      value: dropdownValue,
      isExpanded: true,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.grey,
      ),
      onChanged: (String newValue) {
        setState(() {
          if (dropdownValue != newValue) {
            DoctorModel.doctorsData = [];
            DoctorModel.topRate = 1;
          }
          dropdownValue = newValue;
        });
      },
      items: ConsultingData.specialties
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
            width: double.infinity,
            child: Text(
              value,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget doctorsList() {
    return DoctorModel.doctorsData.length == 0
        ? Center(
            child: Text('No doctors are added yet'),
          )
        : ListView.builder(
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
                        "Name: " + DoctorModel.doctorsData[index].name,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(5.0),
                        child: Text(
                          "Phone: " + DoctorModel.doctorsData[index].phone,
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        )),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(5.0),
                        child: Text(
                          "Address: " + DoctorModel.doctorsData[index].address,
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        )),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Text(
                              "Rate: ",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            ...rate(((DoctorModel.doctorsData[index].rate /
                                        DoctorModel.topRate) *
                                    5)
                                .round()),
                          ],
                        )),
                  ],
                ),
              ));
            },
            itemCount: DoctorModel.doctorsData.length);
  }

  List<Widget> rate(int val) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      stars.add(
          Icon(i < val ? Icons.star : Icons.star_border, color: Colors.yellow));
    }
    return stars;
  }
}
