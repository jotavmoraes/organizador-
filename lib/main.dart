import 'package:flutter/material.dart';

void main() {
  runApp(const MeusGastosApp());
}

class MeusGastosApp extends StatelessWidget {
  const MeusGastosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Organizador Financeiro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double saldo = 1500.00;
  List<Map<String, dynamic>> transacoes = [
    {'titulo': 'Salário', 'valor': 2500.00, 'tipo': 'entrada'},
    {'titulo': 'Supermercado', 'valor': 450.00, 'tipo': 'saida'},
    {'titulo': 'Academia', 'valor': 100.00, 'tipo': 'saida'},
    {'titulo': 'Internet', 'valor': 90.00, 'tipo': 'saida'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Finanças', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Column(
              children: [
                const Text('Saldo Disponível', style: TextStyle(fontSize: 16, color: Colors.teal)),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${saldo.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: saldo >= 0 ? Colors.green.shade700 : Colors.red),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text('Últimas Transações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transacoes.length,
              itemBuilder: (context, index) {
                final item = transacoes[index];
                final isEntrada = item['tipo'] == 'entrada';
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isEntrada ? Colors.green.shade100 : Colors.red.shade100,
                    child: Icon(isEntrada ? Icons.arrow_upward : Icons.arrow_downward, color: isEntrada ? Colors.green : Colors.red),
                  ),
                  title: Text(item['titulo'], style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Text(
                    '${isEntrada ? "+ " : "- "}R\$ ${item['valor'].toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: isEntrada ? Colors.green.shade700 : Colors.red.shade700),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          final tituloController = TextEditingController();
          final valorController = TextEditingController();

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Novo Gasto / Entrada'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: tituloController,
                      decoration: const InputDecoration(labelText: 'Descrição (Ex: Lanche)'),
                    ),
                    TextField(
                      controller: valorController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Valor R\$ (Use - para gastos)'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final String titulo = tituloController.text;
                      final double? valor = double.tryParse(valorController.text);

                      if (titulo.isNotEmpty && valor != null) {
                        setState(() {
                          final String tipo = valor >= 0 ? 'entrada' : 'saida';
                          transacoes.add({
                            'titulo': titulo,
                            'valor': valor.abs(),
                            'tipo': tipo,
                          });
                          saldo += valor;
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Adicionar'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
