/**
 * Main Application
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:shopai_fe/core/theme/app_theme.dart';
import 'package:shopai_fe/core/injection_container.dart' as di;

import 'package:shopai_fe/features/product/domain/entities/product.dart';

import 'package:shopai_fe/features/product/presentation/bloc/product_bloc.dart';
import 'package:shopai_fe/features/ai/presentation/bloc/chat/chat_bloc.dart';

import 'package:shopai_fe/features/product/presentation/pages/product_page.dart';
import 'package:shopai_fe/features/product/presentation/pages/create_product_page.dart';
import 'package:shopai_fe/features/product/presentation/pages/edit_product_page.dart';
import 'package:shopai_fe/features/product/presentation/pages/product_detail_page.dart';
import 'package:shopai_fe/features/ai/presentation/pages/ai_chat_page.dart';
import 'package:shopai_fe/features/home/presentation/pages/main_navigation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(ShopAIApp(router: _router));
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainNavigationPage(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductPage(),
    ),
    GoRoute(
      path: '/create-product',
      builder: (context, state) => const CreateProductPage(),
    ),
    GoRoute(
      path: '/edit-product',
      builder: (context, state) {
        final product = state.extra as Product?;
        return product != null
            ? EditProductPage(product: product)
            : const ProductPage();
      },
    ),
    GoRoute(
      path: '/product-detail',
      builder: (context, state) {
        final product = state.extra as Product?;
        return product != null
            ? ProductDetailPage(product: product)
            : const ProductPage();
      },
    ),
    GoRoute(
      path: '/ai-chat',
      builder: (context, state) => const AiChatPage(),
    ),
  ],
);

class ShopAIApp extends StatelessWidget {
  final GoRouter router;

  const ShopAIApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              di.sl<ProductBloc>()..add(const LoadProductsEvent()),
        ),
        BlocProvider(
          create: (_) => di.sl<ChatBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'ShopAI - E-commerce',
        debugShowCheckedModeBanner: false,
        routerConfig: router,

        theme: ThemeData(
          primaryColor: AppTheme.primaryColor,
          scaffoldBackgroundColor: AppTheme.backgroundColor,

          appBarTheme: AppBarTheme(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
          ),

          // ✅ FIX FLUTTER BARU (CardThemeData BUKAN CardTheme)
          cardTheme: CardThemeData(
            color: AppTheme.surfaceColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppTheme.skyBlueLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.skyBlue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.skyBlue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
          ),

          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}