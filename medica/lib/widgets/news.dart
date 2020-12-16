import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import '../models/news.dart';
import '../screens/web_screen.dart';

class NewsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => WebViewLoad(index > 0
                        ? NewsModel.newsData[index].url
                        : "https://www.care.gov.eg/EgyptCare/index.aspx")));
              },
              child: Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: Column(children: [
                  index > 0
                      ? Image.network(
                          NewsModel.newsData[index].image,
                          fit: BoxFit.fill,
                        )
                      : Image.asset("assets/images/EgyptCare.jpg",
                          fit: BoxFit.fill),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(index > 0
                          ? NewsModel.newsData[index].source
                          : "www.care.gov.eg"),
                      Text(Jiffy(index > 0
                              ? NewsModel.newsData[index].date
                              : DateTime.now())
                          .yMMMMd),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      index > 0
                          ? NewsModel.newsData[index].title
                          : "اّخر أخبار فيروس كورونا المستجد بمصر",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  )
                ]),
              ),
            );
          },
          itemCount: NewsModel.newsLength + 1,
        ));
  }
}
