import 'package:flutter/material.dart';
import 'produto.dart'; // usa a classe definida externamente

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Produto> produtos = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Produtos',
      home: CadastroProdutoPage(
        onProdutoAdicionado: (produto) {
          setState(() {
            produtos.add(produto);
          });
        },
        produtos: produtos,
      ),
    );
  }
}

class CadastroProdutoPage extends StatefulWidget {
  final Function(Produto) onProdutoAdicionado;
  final List<Produto> produtos;

  CadastroProdutoPage({
    required this.onProdutoAdicionado,
    required this.produtos,
  });

  @override
  State<CadastroProdutoPage> createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final _formKey = GlobalKey<FormState>();

  String nome = '', descricao = '', categoria = '', imagemUrl = '';
  double precoCompra = 0, precoVenda = 0, desconto = 0;
  int quantidade = 0;
  bool ativo = false, promocao = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // ✅ Cor de fundo clara
      appBar: AppBar(title: Text("Cadastrar Produto")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Nome"),
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (v) => nome = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Preço de Compra"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (v) => precoCompra = double.parse(v!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Preço de Venda"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (v) => precoVenda = double.parse(v!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Quantidade"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (v) => quantidade = int.parse(v!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Descrição"),
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (v) => descricao = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Categoria"),
                onSaved: (v) => categoria = v ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Imagem (URL)"),
                onSaved: (v) => imagemUrl = v ?? '',
              ),
              SwitchListTile(
                title: Text("Produto Ativo"),
                value: ativo,
                onChanged: (val) => setState(() => ativo = val),
              ),
              CheckboxListTile(
                title: Text("Em Promoção"),
                value: promocao,
                onChanged: (val) => setState(() => promocao = val ?? false),
              ),
              Text("Desconto: ${desconto.toStringAsFixed(0)}%"),
              Slider(
                min: 0,
                max: 100,
                value: desconto,
                onChanged: (val) => setState(() => desconto = val),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Produto novo = Produto(
                      nome: nome,
                      precoCompra: precoCompra,
                      precoVenda: precoVenda,
                      quantidade: quantidade,
                      descricao: descricao,
                      categoria: categoria,
                      imagemUrl: imagemUrl,
                      ativo: ativo,
                      promocao: promocao,
                      desconto: desconto,
                    );
                    widget.onProdutoAdicionado(novo);

                    // ✅ Mostra mensagem de sucesso
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("✅ Produto cadastrado com sucesso!"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // ✅ Navega para a tela de listagem
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ListaProdutosPage(produtos: widget.produtos),
                      ),
                    );
                  }
                },
                child: Text("Cadastrar Produto"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListaProdutosPage extends StatelessWidget {
  final List<Produto> produtos;

  ListaProdutosPage({required this.produtos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Produtos")),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final p = produtos[index];
          return ListTile(
            leading: Image.network(
              p.imagemUrl,
              width: 50,
              height: 50,
              errorBuilder: (c, e, s) => Icon(Icons.broken_image),
            ),
            title: Text(p.nome),
            subtitle: Text("R\$ ${p.precoVenda.toStringAsFixed(2)}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalhesProdutoPage(produto: p),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetalhesProdutoPage extends StatelessWidget {
  final Produto produto;

  DetalhesProdutoPage({required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes do Produto")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Image.network(
              produto.imagemUrl,
              height: 200,
              errorBuilder: (c, e, s) => Icon(Icons.broken_image, size: 200),
            ),
            SizedBox(height: 10),
            Text(
              "Nome: ${produto.nome}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Categoria: ${produto.categoria}"),
            Text("Descrição: ${produto.descricao}"),
            Text("Preço de Compra: R\$ ${produto.precoCompra}"),
            Text("Preço de Venda: R\$ ${produto.precoVenda}"),
            Text("Quantidade: ${produto.quantidade}"),
            Text("Desconto: ${produto.desconto.toStringAsFixed(0)}%"),
            Row(
              children: [
                Icon(
                  produto.ativo ? Icons.check_circle : Icons.cancel,
                  color: produto.ativo ? Colors.green : Colors.red,
                ),
                SizedBox(width: 5),
                Text(produto.ativo ? "Ativo" : "Inativo"),
              ],
            ),
            Row(
              children: [
                Icon(
                  produto.promocao
                      ? Icons.local_offer
                      : Icons.remove_circle_outline,
                  color: produto.promocao ? Colors.orange : Colors.grey,
                ),
                SizedBox(width: 5),
                Text(produto.promocao ? "Em promoção" : "Sem promoção"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
