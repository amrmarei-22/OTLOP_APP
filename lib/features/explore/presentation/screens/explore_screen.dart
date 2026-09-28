import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlop_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/brands_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/categories_cubit.dart';
import 'package:otlop_app/features/home/presentation/screens/filter_products_screen.dart';
import 'package:otlop_app/features/home/presentation/states/brands_states.dart';
import 'package:otlop_app/features/home/presentation/states/categories_states.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().getCategories();
    context.read<BrandsCubitCubit>().getBrands();
  }

  void _openCategory(Map category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CartCubit>(),
          child: FilterProductsScreen(
            title: '${category['name']} Products',
            catId: category['id'],
          ),
        ),
      ),
    );
  }

  void _openBrand(Map brand) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CartCubit>(),
          child: FilterProductsScreen(
            title: '${brand['name']} Products',
            brandId: brand['id'],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              context.read<CategoriesCubit>().getCategories(),
              context.read<BrandsCubitCubit>().getBrands(),
            ]);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
            children: [
              Text(
                'Explore',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Browse by category or brand',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 28),
              const _SectionTitle('CATEGORIES'),
              const SizedBox(height: 14),
              BlocBuilder<CategoriesCubit, CategoriesStates>(
                builder: (context, state) {
                  if (state is CategoriesLoadingState ||
                      state is CategoriesInitialState) {
                    return const SizedBox(
                      height: 170,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is CategoriesErrorState) {
                    return _MessageTile(message: state.error);
                  }
                  if (state is CategoriesSuccessState) {
                    return _CategoriesGrid(
                      categories: state.categories,
                      onTap: _openCategory,
                    );
                  }
                  return const _MessageTile(message: 'No categories found');
                },
              ),
              const SizedBox(height: 30),
              const _SectionTitle('BRANDS'),
              const SizedBox(height: 14),
              BlocBuilder<BrandsCubitCubit, BrandsCubitState>(
                builder: (context, state) {
                  if (state is BrandsCubitLoading ||
                      state is BrandsCubitInitial) {
                    return const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is BrandsCubitError) {
                    return _MessageTile(message: state.error);
                  }
                  if (state is BrandsCubitSuccess) {
                    return _BrandsList(brands: state.brands, onTap: _openBrand);
                  }
                  return const _MessageTile(message: 'No brands found');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      title,
      style: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _CategoriesGrid extends StatelessWidget {
  final List categories;
  final ValueChanged<Map> onTap;

  static const Map<String, String> categoryIcons = {
    'Frappuccino': 'assets/icons/frappe-svgrepo-com.svg',
    'Mocha': 'assets/icons/mocha-svgrepo-com.svg',
    'Latte': 'assets/icons/latte.svg',
    'Macchiato': 'assets/icons/Frapp.svg',
    'Matcha': 'assets/icons/cocktail-svgrepo-com.svg',
    'Donuts':
        'assets/icons/donut-doughnut-sweet-dessert-food-fastfood-svgrepo-com.svg',
    'Cake': 'assets/icons/cake-svgrepo-com.svg',
    'Salad': 'assets/icons/salad-svgrepo-com.svg',
  };

  const _CategoriesGrid({required this.categories, required this.onTap});

  static const tileColors = [
    Color(0xFFFFF2EC), // Soft warm peach
    Color(0xFFFFF7EC), // Soft warm latte / honey
    Color(0xFFF7F3EE), // Soft almond cream
    Color(0xFFFFF0F3), // Soft strawberry cream
    Color(0xFFF1F6F2), // Soft sage cream
    Color(0xFFFFF5EA), // Soft apricot
    Color(0xFFF4F3F8), // Soft vanilla tint
    Color(0xFFF2F4F7), // Soft neutral warm grey
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 69,
      ),
      itemBuilder: (context, index) {
        final category = categories[index] as Map;
        return Material(
          color: colorScheme.brightness == Brightness.dark
              ? colorScheme.surfaceContainerHighest
              : tileColors[index % tileColors.length],
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onTap(category),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  _CategoryIcon(
                    iconPath: categoryIcons[category['name']?.toString()],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category['name']?.toString() ?? 'Category',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final String? iconPath;

  const _CategoryIcon({required this.iconPath});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (iconPath == null) {
      return Icon(
        Icons.category_outlined,
        size: 27,
        color: colorScheme.onSurface,
      );
    }
    return SvgPicture.asset(
      iconPath!,
      width: 28,
      height: 32,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.category_outlined, size: 27, color: colorScheme.onSurface),
    );
  }
}

class _BrandsList extends StatelessWidget {
  final List brands;
  final ValueChanged<Map> onTap;

  const _BrandsList({required this.brands, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: brands.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final brand = brands[index] as Map;
        final name = brand['name']?.toString() ?? 'Brand';
        return Material(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onTap(brand),
            child: SizedBox(
              height: 78,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        name.isEmpty ? '?' : name[0].toUpperCase(),
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MessageTile extends StatelessWidget {
  final String message;

  const _MessageTile({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(child: Text(message, textAlign: TextAlign.center)),
    );
  }
}
