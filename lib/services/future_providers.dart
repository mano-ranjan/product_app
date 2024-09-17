import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_app/models/product_model.dart';
import 'package:product_app/services/get_product_list_api.dart';

final getProductsFutureProvider =
    FutureProvider<List<ProductModel>>((ref) async {
  return (await fetchProducts()); //Warning
});
