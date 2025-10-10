import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../data/services/api_service.dart';
import '../data/repositories/product_repository.dart';
import '../presentation/providers/product_provider.dart';
import '../presentation/screens/home/home_screen.dart';
import '../core/constants/string_constants.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
          dispose: (_, apiService) => apiService.dispose(),
        ),
        Provider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(
            apiService: context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(
            repository: context.read<ProductRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: StringConstants.appTitle,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
