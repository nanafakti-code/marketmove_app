import 'package:flutter/material.dart';

class ResumenPage extends StatefulWidget {
  const ResumenPage({super.key});

  @override
  State<ResumenPage> createState() => _ResumenPageState();
}

class _ResumenPageState extends State<ResumenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Resumen'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome message
            Card(
              color: Colors.indigo[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.dashboard, size: 48, color: Colors.indigo),
                    const SizedBox(height: 8),
                    Text(
                      'Bienvenido a MarketMove',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gestiona tu negocio de forma eficiente',
                      style: TextStyle(color: Colors.indigo[700]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Financial summary
            Text(
              'Resumen Financiero',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Ventas',
                    '\$0.00',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Gastos',
                    '\$0.00',
                    Icons.trending_down,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSummaryCard(
              'Balance',
              '\$0.00',
              Icons.account_balance_wallet,
              Colors.blue,
            ),
            const SizedBox(height: 24),

            // Quick actions
            Text(
              'Acciones Rápidas',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildQuickActionCard(
                  context,
                  'Ventas',
                  Icons.attach_money,
                  Colors.green,
                  '/ventas',
                ),
                _buildQuickActionCard(
                  context,
                  'Gastos',
                  Icons.money_off,
                  Colors.red,
                  '/gastos',
                ),
                _buildQuickActionCard(
                  context,
                  'Productos',
                  Icons.inventory,
                  Colors.purple,
                  '/productos',
                ),
                _buildQuickActionCard(
                  context,
                  'Reportes',
                  Icons.bar_chart,
                  Colors.orange,
                  null,
                ),
              ],
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
        child: Row(
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String? route,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (route != null) {
            Navigator.pushNamed(context, route);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Funcionalidad en desarrollo')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
            decoration: BoxDecoration(color: Colors.indigo),
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
            selected: true,
            onTap: () => Navigator.pop(context),
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
            onTap: () => Navigator.pushReplacementNamed(context, '/productos'),
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
