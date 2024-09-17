import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:product_app/models/product_model.dart';
import 'package:product_app/services/future_providers.dart';
import 'package:product_app/views/product_details_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const int itemsPerPage = 5;
  List<ProductModel> displayedProducts = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      // Simulating an API call delay
      Future.delayed(const Duration(seconds: 1), () {
        final allProducts = ref.read(getProductsFutureProvider).value ?? [];
        final newItems = allProducts
            .skip(displayedProducts.length)
            .take(itemsPerPage)
            .toList();

        setState(() {
          displayedProducts.addAll(newItems);
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var getProductsFutureProviderInstance =
        ref.watch(getProductsFutureProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: getProductsFutureProviderInstance.when(
          data: (productData) {
            if (displayedProducts.isEmpty) {
              displayedProducts = productData.take(itemsPerPage).toList();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image.network(
                //   "https://i.ytimg.com/vi/laCgnYBek_s/maxresdefault.jpg",
                //   fit: BoxFit.fill,
                // ),
                Lottie.asset("assets/json/product_json.json"),
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text(
                    "Product Tour",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: displayedProducts.length + 1,
                      itemBuilder: (context, index) {
                        if (index < displayedProducts.length) {
                          final product = displayedProducts[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailScreen(product: product),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      height: 80,
                                      width: 80,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          product.image!,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    height: 70,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width -
                                                  184,
                                          height: 50,
                                          child: Text(
                                            product.title!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              product.rating!.rate.toString(),
                                            ),
                                            const Icon(
                                              Icons.star,
                                              size: 12,
                                              color: Colors.orange,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                          return ListTile(
                            title: Text(product.title ?? ''),
                            subtitle: Text(product.price?.toString() ?? ''),
                          );
                        } else if (isLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: 30,
                              ),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          },
          error: (err, stack) {
            return Center(
              child: Text(
                err.toString(),
              ),
            );
          },
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
