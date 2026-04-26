/**
 * Product Page
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopai_fe/core/theme/app_theme.dart';
import 'package:shopai_fe/features/product/presentation/bloc/product_bloc.dart';
import 'package:shopai_fe/features/product/presentation/widgets/product_item_widget.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: const SizedBox(),
        title: const Text(
          'ShopAI - Products',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial || state is ProductLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
          }
          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(const LoadProductsEvent());
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                    child: const Text('Retry', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }
          if (state is ProductsLoaded) {
            if (state.products.isEmpty) {
              return const Center(
                child: Text(
                  'No products available',
                  style: TextStyle(color: AppTheme.textColor, fontSize: 16),
                ),
              );
            }
            return RefreshIndicator(
              color: AppTheme.primaryColor,
              onRefresh: () async {
                context.read<ProductBloc>().add(const LoadProductsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductItemWidget(product: product);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
