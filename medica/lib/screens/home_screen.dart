import 'package:flutter/material.dart';
import 'package:medica/models/consulting.dart';
import 'package:medica/models/doctors.dart';
import 'package:medica/models/pharmacy.dart';
import 'package:medica/models/auth.dart';
import 'package:medica/widgets/addUser.dart';
import 'package:medica/widgets/news.dart';
import '../widgets/app_drawer.dart';
import '../models/news.dart';
import '../widgets/hospital.dart';
import '../widgets/test.dart';
import '../widgets/consultation.dart';
import '../models/hospitals.dart';
import '../models/quiz.dart';
import '../widgets/addConsulting.dart';
import '../widgets/doctors.dart';
import '../widgets/pharmacies.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = false;
  var _subScrrens = Auth.type == 'admin' ? 'Add Doctor' : 'News';
  int bottomBarIndex = 0;

  void changeSubScreen(String title) {
    setState(() {
      _subScrrens = title;
    });
  }

  Widget screenWidget() {
    switch (_subScrrens) {
      case 'News':
        return NewsModel.newsData.isNotEmpty
            ? NewsWidget()
            : FutureBuilder(
                future: NewsModel.fetchNews(),
                builder: (ctx, fetchResultSnapshot) =>
                    fetchResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : NewsWidget());
      case 'Hospitals':
        return HospitalData.hospitalData.isNotEmpty
            ? HospitalWidget()
            : FutureBuilder(
                future: HospitalData.fetchHospitals(),
                builder: (ctx, fetchResultSnapshot) =>
                    fetchResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : HospitalWidget());

      case 'Symptoms Test':
        return QuizData.questions.isNotEmpty
            ? TestWidget()
            : FutureBuilder(
                future: QuizData.fetchQuiz(),
                builder: (ctx, fetchResultSnapshot) =>
                    fetchResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : TestWidget());

      case 'Consultings':
        return ConsultingData.consultingsData.isNotEmpty
            ? ConsultationWidget()
            : FutureBuilder(
                future: ConsultingData.fetchconsultingsData(),
                builder: (ctx, fetchResultSnapshot) =>
                    fetchResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : ConsultationWidget());
      case 'Doctors':
        return ConsultingData.specialties.isNotEmpty
            ? DoctorsWidget()
            : FutureBuilder(
                future: ConsultingData.fetchSpecialties(),
                builder: (ctx, fetchResultSnapshot) =>
                    fetchResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : DoctorsWidget());
      case 'Pharmacies':
        return PharmacyModel.pharmaciesData.isNotEmpty
            ? PharmaciesWidget()
            : FutureBuilder(
                future: PharmacyModel.fetchpharmacies(),
                builder: (ctx, fetchResultSnapshot) =>
                    fetchResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : PharmaciesWidget());
      case 'Add Doctor':
        return ConsultingData.specialties.isNotEmpty
            ? AddUser('doctor')
            : FutureBuilder(
                future: ConsultingData.fetchSpecialties(),
                builder: (ctx, fetchResultSnapshot) =>
                    fetchResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : AddUser('doctor'));
      case 'Add Pharmacy':
        return AddUser('pharmacy');
      default:
        return Center();
    }
  }

  @override
  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(_subScrrens),
        centerTitle: true,
        actions: Auth.type != 'admin'
            ? null
            : [
                IconButton(
                  icon: Icon(
                    Icons.logout,
                  ),
                  onPressed: () {
                    Auth.logout();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => AuthScreen()));
                  },
                ),
              ],
      ),
      bottomNavigationBar: Auth.type != 'admin'
          ? null
          : BottomNavigationBar(
              currentIndex: bottomBarIndex,
              onTap: (value) {
                if (bottomBarIndex != value) {
                  setState(() {
                    bottomBarIndex = value;
                    switch (bottomBarIndex) {
                      case 0:
                        _subScrrens = 'Add Doctor';
                        break;
                      case 1:
                        _subScrrens = 'Add Pharmacy';
                        break;
                      default:
                        _subScrrens = 'Add Doctor';
                    }
                  });
                }
              },
              items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add), label: "Doctor"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add), label: "Pharmacy")
                ]),
      drawer: Auth.type == 'admin' ? null : AppDrawer(changeSubScreen),
      body: screenWidget(),
      floatingActionButton: Auth.type == 'admin'
          ? null
          : FloatingActionButton(
              onPressed: () {
                if (_subScrrens == 'Consultings') {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => AddConsultings(changeSubScreen)));
                } else {
                  _clearData();
                  NewsModel.newsData = [];
                  setState(() {
                    isLoading = true;
                  });
                }
              },
              child: Icon(
                  _subScrrens == 'Consultings' ? Icons.add : Icons.refresh),
            ),
    );
  }

  void _clearData() {
    switch (_subScrrens) {
      case 'News':
        NewsModel.newsData = [];
        break;
      case 'Hospitals':
        HospitalData.hospitalData = [];
        break;
      case 'Symptoms Test':
        QuizData.answers = [];
        QuizData.diseases = [];
        QuizData.questions = [];
        QuizData.answersOfDiseses = {};
        break;
      case 'Doctors':
        ConsultingData.specialties = [];
        DoctorModel.doctorsData = [];
        break;
      case 'Pharmacies':
        PharmacyModel.pharmaciesData = [];
        break;
      default:
        return;
    }
  }
}
