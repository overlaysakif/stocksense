import 'package:flutter/material.dart';

import '../models/product.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.products,
    required this.onViewInventory,
    required this.onScan,
    required this.onAddProduct,
  });

  final List<Product> products;
  final VoidCallback onViewInventory;
  final VoidCallback onScan;
  final VoidCallback onAddProduct;

  @override
  Widget build(BuildContext context) {
    final lowStockCount = products.where((product) => product.isLowStock).length;
    final totalUnits = products.fold<int>(
      0,
      (sum, product) => sum + product.quantity,
    );
    final inventoryValue = products.fold<double>(
      0,
      (sum, product) => sum + (product.price * product.quantity),
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'StockSense',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'A quick overview of your inventory.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth - 12) / 2;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _MetricCard(
                      width: width,
                      icon: Icons.inventory_2_outlined,
                      label: 'Products',
                      value: products.length.toString(),
                    ),
                    _MetricCard(
                      width: width,
                      icon: Icons.warning_amber_rounded,
                      label: 'Low stock',
                      value: lowStockCount.toString(),
                    ),
                    _MetricCard(
                      width: width,
                      icon: Icons.layers_outlined,
                      label: 'Total units',
                      value: totalUnits.toString(),
                    ),
                    _MetricCard(
                      width: width,
                      icon: Icons.payments_outlined,
                      label: 'Stock value',
                      value: '\$${inventoryValue.toStringAsFixed(0)}',
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),
            Text(
              'Quick actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            _ActionTile(
              icon: Icons.add_box_outlined,
              title: 'Add a product',
              subtitle: 'Create a new inventory record',
              onTap: onAddProduct,
            ),
            const SizedBox(height: 10),
            _ActionTile(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Scan product',
              subtitle: 'Use the camera to identify an item',
              onTap: onScan,
            ),
            const SizedBox(height: 10),
            _ActionTile(
              icon: Icons.list_alt_rounded,
              title: 'View inventory',
              subtitle: 'Search, review and manage stock',
              onTap: onViewInventory,
            ),
            if (lowStockCount > 0) ...[
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$lowStockCount item${lowStockCount == 1 ? '' : 's'} need attention',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Review low-stock products before they run out.',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
  });

  final double width;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
