import 'package:assigment/src/models/prodcut.dart';
import 'package:assigment/src/utility.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List of hardcoded images for products.
  List<String> hardcodedImages = [
    'https://nurserynisarga.in/wp-content/uploads/2021/08/Hot-climate-Apple.jpg',
    'https://www.bangaloreagrico.in/wp-content/uploads/2018/11/sindhu.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQX2v_4XkJ7TID3K-hQayioFl6SBDjjDHO8g&usqp=CAU',
    'https://images.unsplash.com/photo-1616679312958-a86d9539afae?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE0fHx8ZW58MHx8fHw%3D&w=1000&q=80',
  ];

  /// Fetch the json data dynamically from file.
  /// with help of the [loadJsonFromFile] function which
  /// read and write the file if it exists other return `null`.
  Future<List<Product>> fetchProduct() async {
    try {
      final List? jsonData = await loadJsonFromFile('assets/data.json');
      // if (jsonData != null) {
      return jsonData!.map((e) => Product.fromJson(e)).toList();
      // }

    } catch (e) {
      throw Exception(e);
    }
  }

  /// Future  for showing the list of product
  /// which insitlized in  [initState] to avoid the unnessery reubuild of
  /// build method if  function [loadJsonFromFile] is directly called in build method.
  late Future<List<Product>> futureProducts;

  /// Can be done using Enum or List<Categories> but for  simplicity using string for now.
  String category = 'Default';

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final filteredData = snapshot.data!
                .where((element) => element.category == category)
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    scrollDirection: Axis.horizontal,
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      FilterChip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                        side: BorderSide.none,
                        onSelected: (value) => setState(() {
                          category = 'Default';
                        }),
                        label: const Text('All'),
                        selected: category == 'Default',
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      FilterChip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                        side: BorderSide.none,
                        onSelected: (value) => setState(() {
                          category = 'Premium';
                        }),
                        label: const Text('Premium'),
                        selected: category == 'Premium',
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      FilterChip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                        side: BorderSide.none,
                        onSelected: (value) => setState(() {
                          category = 'Tamilnadu';
                        }),
                        label: const Text('TamilNadu'),
                        selected: category == 'Tamilnadu',
                      )
                    ])),
                Expanded(
                  child: ListView.builder(
                      itemCount: category == 'Default'
                          ? snapshot.data!.length
                          : filteredData.length,
                      itemBuilder: (context, index) {
                        final product = category == 'Default'
                            ? snapshot.data![index]
                            : filteredData[index];
                        final image = hardcodedImages[index];
                        return ProductCard(
                            hardcodedImage: image, product: product);
                      }),
                ),
              ],
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.hardcodedImage,
    required this.product,
  }) : super(key: key);

  final String hardcodedImage;
  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 0;
  void updateIncrement() {
    if (_quantity >= 0) _quantity++;

    setState(() {});
  }

  void updateDecrement() {
    if (_quantity > 0) _quantity--;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(right: 0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.hardcodedImage,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product Name : ${widget.product.name}'),
                    Text(
                      'Cost : ${widget.product.cost}',
                    ),
                    Text(
                      'Availibility : ${widget.product.availibility}',
                    ),
                    Text('Details : ${widget.product.details}'),
                    Text('Category : ${widget.product.category}'),
                  ],
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                    ),
                    onPressed: () {
                      updateIncrement();
                    },
                    child: const Icon(Icons.add),
                  ),
                  Text(
                    _quantity.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                    ),
                    onPressed: () {
                      updateDecrement();
                    },
                    child: const Icon(Icons.remove),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
