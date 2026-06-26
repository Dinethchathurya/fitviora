import 'food_variant_model.dart';

class FoodItemModel {
  const FoodItemModel({
    required this.id,
    required this.name,
    required this.localNames,
    this.description,
    required this.category,
    required this.mealTypes,
    required this.variants,
  });

  final String id;
  final String name;
  final List<String> localNames;
  final String? description;

  final String category;
  final List<String> mealTypes;

  final List<FoodVariantModel> variants;

  FoodVariantModel? get defaultVariant {
    if (variants.isEmpty) return null;
    return variants.firstWhere(
      (v) => v.isDefaultVariant,
      orElse: () => variants.first,
    );
  }

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      localNames: (json['localNames'] as List<dynamic>).cast<String>(),
      description: json['description'] as String?,
      category: json['category'] as String,
      mealTypes: (json['mealTypes'] as List<dynamic>).cast<String>(),
      variants: (json['variants'] as List<dynamic>)
          .map((e) => FoodVariantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'localNames': localNames,
      'description': description,
      'category': category,
      'mealTypes': mealTypes,
      'variants': variants.map((v) => v.toJson()).toList(),
    };
  }

  FoodItemModel copyWith({
    String? id,
    String? name,
    List<String>? localNames,
    String? description,
    String? category,
    List<String>? mealTypes,
    List<FoodVariantModel>? variants,
  }) {
    return FoodItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      localNames: localNames ?? this.localNames,
      description: description ?? this.description,
      category: category ?? this.category,
      mealTypes: mealTypes ?? this.mealTypes,
      variants: variants ?? this.variants,
    );
  }
}

