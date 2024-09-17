import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:product_app/models/product_model.dart';

Future<List<ProductModel>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => ProductModel.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
