import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  var apiKey = 'AIzaSyA9yMVvxWwADV57ZPAS7vuiCcTvR0LKV1Y';
  var url = 'https://www.googleapis.com/books/v1/volumes?q=flowers+inauthor:keyes&key=$apiKey';
  var res = await http.get(url);
  var data = jsonDecode(res.body);
  print(data['items'][1]['volumeInfo']['publisher']);
}