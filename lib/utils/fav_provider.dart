import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_app/models/product_model.dart';

final favoriteProductsProvider =
    StateNotifierProvider<FavoriteNotifier, Set<ProductModel>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<Set<ProductModel>> {
  FavoriteNotifier() : super({});

  void toggleFavorite(ProductModel product) {
    if (state.contains(product)) {
      state = {...state}..remove(product);
    } else {
      state = {...state}..add(product);
    }
  }

  bool isFavorite(ProductModel product) {
    return state.contains(product);
  }
}
