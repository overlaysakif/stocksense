import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import 'product_detail_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({
    super.key,
    required this.products,
    required this.onAddProduct,
    required this.productService,
  });

  final List<Product> products;
  final VoidCallback onAddProduct;
  final ProductService productService;

  @override
  State<InventoryScreen> createState() =>
      _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _query = '';
  bool _lowStockOnly = false;

  Future<void> _openProduct(Product product) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => ProductDetailScreen(
          product: product,
          productService: widget.productService,
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    if (result == 'updated') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product updated successfully.'),
        ),
      );
    }

    if (result == 'deleted') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = _query.trim().toLowerCase();

    final filteredProducts = widget.products.where((product) {
      final matchesQuery = normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery) ||
          product.sku.toLowerCase().contains(normalizedQuery) ||
          product.barcode.toLowerCase().contains(normalizedQuery) ||
          product.category.toLowerCase().contains(normalizedQuery);

      final matchesStock =
          !_lowStockOnly || product.isLowStock;

      return matchesQuery && matchesStock;
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inventory',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.products.length} products in stock',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: widget.onAddProduct,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add'),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search name, SKU or barcode',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.fromLTRB(20, 12, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                selected: _lowStockOnly,
                avatar: const Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                ),
                label: const Text('Low stock only'),
                onSelected: (selected) {
                  setState(() {
                    _lowStockOnly = selected;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? _EmptyState(
                    query: _query,
                    lowStockOnly: _lowStockOnly,
                  )
                : ListView.separated(
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      6,
                      20,
                      110,
                    ),
                    itemCount: filteredProducts.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final product =
                          filteredProducts[index];

                      return Card(
                        child: InkWell(
                          borderRadius:
                              BorderRadius.circular(12),
                          onTap: () =>
                              _openProduct(product),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration:
                                      BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius:
                                        BorderRadius.circular(
                                      14,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons
                                        .inventory_2_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow
                                            .ellipsis,
                                        style: Theme.of(
                                          context,
                                        )
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight:
                                                  FontWeight
                                                      .w700,
                                            ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${product.sku} • ${product.category}',
                                        style: TextStyle(
                                          color: Colors
                                              .grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${product.quantity}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight:
                                                FontWeight
                                                    .w800,
                                          ),
                                    ),
                                    Text(
                                      product.isLowStock
                                          ? 'Low'
                                          : 'In stock',
                                      style: TextStyle(
                                        color:
                                            product.isLowStock
                                                ? Theme.of(
                                                    context,
                                                  )
                                                    .colorScheme
                                                    .error
                                                : Colors.grey
                                                    .shade700,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.query,
    required this.lowStockOnly,
  });

  final String query;
  final bool lowStockOnly;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'No products found',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              lowStockOnly
                  ? 'Try turning off the low-stock filter.'
                  : 'Try a different search term.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}