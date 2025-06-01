import 'package:trabalhomobileflutter/Page/components/list_item.dart';
import 'package:trabalhomobileflutter/database/product_database';
import 'package:flutter/material.dart';

import '../model/produto.model.dart';
import 'product_form_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  Future<List<ProdutoModel>> _carregaProdutos() async {
    final db = ProductDatabase();
    return await db.findAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Produtos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: const [
          IconButton(
            icon: Icon(Icons.list, color: Colors.white),
            onPressed: null,
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple[100],
      body: Scaffold(
        backgroundColor: Colors.grey[100],
        body: FutureBuilder<List<ProdutoModel>>(
          future: _carregaProdutos(),
          builder: (context, snapshort) {
            if (snapshort.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blueGrey),
              );
            } else if (snapshort.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar a lista de produtos: ${snapshort.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshort.hasData || snapshort.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum produto cadastrado.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            final listaProduto = snapshort.data!;
            return ListView.builder(
              itemCount: listaProduto.length,
              itemBuilder: (context, index) {
                final produto = snapshort.data![index];
                return ListItem(product: produto);
              },
            );
          },
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            ProdutoModel? produto = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductFormPage()),
            );
            if (produto != null) {
              final db = ProductDatabase();
              await db.insertProduct(produto);
            }
            setState(() {});
          },
          label: const Text(
            'Novo Produto',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
