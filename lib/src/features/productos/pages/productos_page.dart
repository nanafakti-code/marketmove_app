import 'package:flutter/material.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos / Stock'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Búsqueda en desarrollo')),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Productos',
                    '0',
                    Icons.inventory_2,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Stock Bajo',
                    '0',
                    Icons.warning,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Add product button
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to add product form
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad en desarrollo')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar Nuevo Producto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),

            // Products list header
            Text(
              'Inventario',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Products list placeholder
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No hay productos registrados',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.purple),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.shopping_cart, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'MarketMove',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Resumen'),
            onTap: () => Navigator.pushReplacementNamed(context, '/resumen'),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Ventas'),
            onTap: () => Navigator.pushReplacementNamed(context, '/ventas'),
          ),
          ListTile(
            leading: const Icon(Icons.money_off),
            title: const Text('Gastos'),
            onTap: () => Navigator.pushReplacementNamed(context, '/gastos'),
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Productos'),
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }
}
