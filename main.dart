import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//This is the file containing our providers
 void main() {
   runApp(
     ProviderScope(
       child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProductPage(),
       ),
     ),
   );
 }

class Product{
  Product({required this.name, required this.price});

  final String name;
  final double price;
}

final _products = [
  Product(name: "Spagetti", price: 10),
  Product(name: "Indomie", price: 6),
  Product(name: "Fried Yam", price: 9),
  Product(name: "Beans", price: 10),
  Product(name: "Red Chicken feet", price: 2),
  Product(name: "Eclipse", price: 19),
  Product(name: "Sandwich", price: 12),
];

enum ProductSortType{
  name,
  price,
}

//This is the default sort type when the app is run
final productSortTypeProvider = StateProvider<ProductSortType>((ref) => 
ProductSortType.name);

final futureProductsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  final sortType = ref.watch(productSortTypeProvider);
switch (sortType) {
    case ProductSortType.name:
       _products.sort((a, b) => a.name.compareTo(b.name));
       break;
    case ProductSortType.price:
       _products.sort((b, a) => a.price.compareTo(b.price));
}
  return _products;
});


class ProductPage extends ConsumerWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final productsProvider = ref.watch(futureProductsProvider);

     AppBar(
          title: const Text("Future Provider Example"),
          actions: [
            DropdownButton<ProductSortType>(
              dropdownColor: Colors.brown,
              value: ref.watch(productSortTypeProvider),
                items: const [
                  DropdownMenuItem(
                    value: ProductSortType.name,
                    child: Icon(Icons.sort_by_alpha),
                ),
                  DropdownMenuItem(
                    value: ProductSortType.price,
                    child: Icon(Icons.sort),
                  ),
                ],
                onChanged: (value)=> ref.watch(productSortTypeProvider.notifier).state = value!
            ),
          ],
        );


        productsProvider.when(
            data: (products)=> ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Card(
                      color: Color.fromARGB(255, 38, 176, 100),
                      elevation: 3,
                      child: ListTile(
                        title: Text(products[index].name,style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                        subtitle: Text("${products[index].price}",style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                      ),
                    ),
                  );
                }),
            error: (err, stack) => Text("Error: $err",style: const TextStyle(
                color: Colors.white,  fontSize: 15)),
            loading: ()=> const Center(child: CircularProgressIndicator(color: Colors.white,)),
        );


    return Scaffold(
        appBar: AppBar(
          title: const Text("Tabla De Clasificacion"),
          actions: [
            DropdownButton<ProductSortType>(
              dropdownColor: const Color.fromARGB(255, 195, 65, 18),
              value: ref.watch(productSortTypeProvider),
                items: const [
                  DropdownMenuItem(
                    value: ProductSortType.name,
                    child: Icon(Icons.sort_by_alpha, color: Colors.blue),
                ),
                  DropdownMenuItem(
                    value: ProductSortType.price,
                    child: Icon(Icons.sort, color: Colors.blue),
                  ),
                ],
                onChanged: (value)=> ref.watch(productSortTypeProvider.notifier).state = value!
            ),
          ],
        ),
      backgroundColor: Color.fromARGB(255, 181, 144, 144),
      body: Container(
        child: productsProvider.when(
            data: (products)=> ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Card(
                      color: Color.fromARGB(255, 191, 58, 58),
                      elevation: 3,
                      child: ListTile(
                        title: Text(products[index].name,style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                        subtitle: Text("${products[index].price}",style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                      ),
                    ),
                  );
                }),
            error: (err, stack) => Text("Error: $err",style: const TextStyle(
                color: Colors.white,  fontSize: 15)),
            loading: ()=> const Center(child: CircularProgressIndicator(color: Colors.white,)),
        ),
      )
    );
  }
}

