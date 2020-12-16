import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsModel {
  static List<News> newsData = [];
  static var newsLength = 0;
  static Future<bool> fetchNews() async {
    final apiKey = '11a44a9de710488d9d2c7ec9341b4471';
    var url =
        'https://newsapi.org/v2/everything?q=%27%D9%83%D9%88%D8%B1%D9%88%D9%86%D8%A7%20%D9%85%D8%B5%D8%B1%27&language=ar&sortBy=publishedAt&apiKey=$apiKey&pageSize=100&page=1';
    try {
      final response = await http.get(url);
      var data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return false;
      }
      newsLength = data['totalResults'] as int;
      for (var i = 0; i < newsLength; i++) {
        newsData.add(News(
            data['articles'][i]['source']['name'],
            data['articles'][i]['title'],
            data['articles'][i]['url'],
            data['articles'][i]['urlToImage'],
            data['articles'][i]['publishedAt']));
      }
    } catch (error) {
      print(error.toString());
    }
    return true;
  }
}

class News {
  final String source;
  final String title;
  final String url;
  final String image;
  final String date;
  News(this.source, this.title, this.url, this.image, this.date);
}
