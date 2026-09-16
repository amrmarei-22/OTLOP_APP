


 abstract class BrandsCubitState {}

final class BrandsCubitInitial extends BrandsCubitState {} 

final class BrandsCubitSuccess extends BrandsCubitState {
  final List brands;
  BrandsCubitSuccess({required this.brands});
}
final class BrandsCubitError extends BrandsCubitState {
  final String error;
  BrandsCubitError({required this.error});
}
final class BrandsCubitLoading extends BrandsCubitState {}