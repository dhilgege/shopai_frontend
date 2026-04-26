/**
 * Main Application
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopai_fe/core/theme/app_theme.dart';
import 'package:shopai_fe/core/injection_container.dart' as di;
import 'package:shopai_fe/features/product/presentation/bloc/product_bloc.dart';
import 'package:shopai_fe/features/home/presentation/pages/home_page.dart';
import 'package:shopai_fe/features/product/presentation/pages/product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const ShopAIApp());
}

class ShopAIApp extends StatelessWidget {
  const ShopAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<ProductBloc>()..add(const LoadProductsEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'ShopAI - E-commerce',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppTheme.primaryColor,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
