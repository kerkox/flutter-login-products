import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';

import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final storage = new FlutterSecureStorage();

    if (productsService.isLoading) {
      print("Esta cargado los productos...");
      return LoadingScreen();
    } else if (productsService.products.length == 0) {
      print("Aqui se ha llamado la carga de productos porque cuando ingresas");
      productsService.loadProducts();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        leading: IconButton(
          icon: Icon(Icons.login_outlined),
          onPressed: () {
            authService.logout();
            productsService.clearProducts();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
      body: ListView.builder(
          itemCount: productsService.products.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  productsService.selectedProduct =
                      productsService.products[index].copy();
                  Navigator.pushNamed(context, 'product');
                },
                child: ProductCard(
                  product: productsService.products[index],
                ),
              )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          print("Se va a ejecutar la creacion de un producto");
          var userId = await storage.read(key: 'userId');
          productsService.selectedProduct = new Product(
              available: false, name: '', price: 0, userId: userId.toString());
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
