import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:shopai_fe/core/theme/app_theme.dart';
import 'package:shopai_fe/features/product/domain/entities/product.dart';
import 'package:shopai_fe/features/product/presentation/bloc/product_bloc.dart';
import 'package:shopai_fe/features/product/presentation/widgets/product_item_widget.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category ?? 'All';
    });
  }

  // ✅ FIX: Product type + null safety
  List<Product> _filterProducts(List<Product> products) {
    return products.where((product) {
      final name = product.name.toLowerCase();
      final desc = product.description.toLowerCase();
      final category = product.category?.toLowerCase() ?? '';

      final matchesSearch =
          name.contains(_searchQuery) || desc.contains(_searchQuery);

      final matchesCategory = _selectedCategory == 'All' ||
          category == _selectedCategory.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();
  }

  Set<String> _getCategories(List<Product> products) {
    return products
        .map((p) => p.category)
        .where((c) => c != null && c.isNotEmpty)
        .cast<String>()
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopAI Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy),
            tooltip: 'AI Assistant',
            onPressed: () {
              context.go('/ai-chat');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // SEARCH
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.skyBlueLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search,
                          color: AppTheme.skyBlueDark),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // CATEGORY
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductsLoaded) {
                      final categories = _getCategories(state.products);

                      return SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            FilterChip(
                              label: const Text('All'),
                              selected: _selectedCategory == 'All',
                              onSelected: (_) =>
                                  _onCategoryChanged('All'),
                            ),
                            const SizedBox(width: 8),
                            ...categories.map(
                              (category) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(category),
                                  selected:
                                      _selectedCategory == category,
                                  onSelected: (_) =>
                                      _onCategoryChanged(category),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      // BODY
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading ||
              state is ProductInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductError) {
            return Center(child: Text(state.message));
          }

          if (state is ProductsLoaded) {
            final filtered = _filterProducts(state.products);

            if (filtered.isEmpty) {
              return const Center(
                child: Text('No products found'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ProductBloc>()
                    .add(const LoadProductsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return ProductItemWidget(
                    product: filtered[index],
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),

      // FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/create-product');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}