import '../../domain/entities/seasonal_food.dart';

class SeasonalFoodDataset {
  const SeasonalFoodDataset._();

  static const List<SeasonalFood> foods = [
    // Fruits

    SeasonalFood(
      id: 'mango',
      name: 'Mango',
      displayName: 'Mango (Amba)',
      localName: 'Amba',
      category: SeasonalFoodCategory.fruit,
      availableMonths: [2, 3, 4, 5, 6, 7],
      emoji: '🥭',
      description: 'A sweet tropical fruit commonly available in Sri Lanka.',
      nutritionTags: [
        'Vitamin C',
        'Vitamin A',
        'Antioxidants',
      ],
      healthBenefits: [
        'Supports immunity',
        'Supports healthy vision',
      ],
    ),

    SeasonalFood(
      id: 'papaya',
      name: 'Papaya',
      displayName: 'Papaya (Papol)',
      localName: 'Papol',
      category: SeasonalFoodCategory.fruit,
      availableMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
      emoji: '🍈',
      description: 'A soft tropical fruit available throughout the year.',
      nutritionTags: [
        'Vitamin C',
        'High Fiber',
      ],
      healthBenefits: [
        'Supports digestion',
        'Supports immunity',
      ],
    ),

    SeasonalFood(
      id: 'pineapple',
      name: 'Pineapple',
      displayName: 'Pineapple (Annasi)',
      localName: 'Annasi',
      category: SeasonalFoodCategory.fruit,
      availableMonths: [1, 2, 3, 4, 5, 6, 7, 8],
      emoji: '🍍',
      description: 'A sweet and slightly acidic tropical fruit.',
      nutritionTags: [
        'Vitamin C',
        'Manganese',
      ],
      healthBenefits: [
        'Supports digestion',
        'Provides antioxidants',
      ],
    ),

    SeasonalFood(
      id: 'banana',
      name: 'Banana',
      displayName: 'Banana (Kesel)',
      localName: 'Kesel',
      category: SeasonalFoodCategory.fruit,
      availableMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
      emoji: '🍌',
      description: 'A widely available fruit and a natural source of energy.',
      nutritionTags: [
        'Potassium',
        'Carbohydrates',
      ],
      healthBenefits: [
        'Provides energy',
        'Supports muscle function',
      ],
    ),

    SeasonalFood(
      id: 'wood_apple',
      name: 'Wood Apple',
      displayName: 'Wood Apple (Divul)',
      localName: 'Divul',
      category: SeasonalFoodCategory.fruit,
      availableMonths: [8, 9, 10, 11, 12],
      emoji: '🟤',
      description: 'A traditional Sri Lankan fruit with a distinct aroma.',
      nutritionTags: [
        'High Fiber',
        'Antioxidants',
      ],
      healthBenefits: [
        'Supports digestion',
      ],
    ),

    SeasonalFood(
      id: 'rambutan',
      name: 'Rambutan',
      displayName: 'Rambutan',
      category: SeasonalFoodCategory.fruit,
      availableMonths: [6, 7, 8],
      emoji: '🔴',
      description: 'A juicy seasonal tropical fruit.',
      nutritionTags: [
        'Vitamin C',
      ],
      healthBenefits: [
        'Supports immunity',
      ],
    ),

    SeasonalFood(
      id: 'avocado',
      name: 'Avocado',
      displayName: 'Avocado (Aligeta Pera)',
      localName: 'Aligeta Pera',
      category: SeasonalFoodCategory.fruit,
      availableMonths: [5, 6, 7, 8, 9],
      emoji: '🥑',
      description: 'A creamy fruit containing healthy fats.',
      nutritionTags: [
        'Healthy Fat',
        'Fiber',
        'Potassium',
      ],
      healthBenefits: [
        'Supports heart health',
        'Provides lasting energy',
      ],
    ),

    // Vegetables

    SeasonalFood(
      id: 'pumpkin',
      name: 'Pumpkin',
      displayName: 'Pumpkin (Wattakka)',
      localName: 'Wattakka',
      category: SeasonalFoodCategory.vegetable,
      availableMonths: [1, 2, 3, 4, 8, 9, 10, 11, 12],
      emoji: '🎃',
      description: 'A nutrient-rich vegetable commonly used in curries.',
      nutritionTags: [
        'Vitamin A',
        'High Fiber',
      ],
      healthBenefits: [
        'Supports healthy vision',
        'Supports digestion',
      ],
    ),

    SeasonalFood(
      id: 'snake_gourd',
      name: 'Snake Gourd',
      displayName: 'Snake Gourd (Pathola)',
      localName: 'Pathola',
      category: SeasonalFoodCategory.vegetable,
      availableMonths: [1, 2, 3, 4, 5, 6],
      emoji: '🥒',
      description: 'A light vegetable commonly prepared as a Sri Lankan curry.',
      nutritionTags: [
        'Low Calorie',
        'High Water Content',
      ],
      healthBenefits: [
        'Supports hydration',
      ],
    ),

    SeasonalFood(
      id: 'bitter_gourd',
      name: 'Bitter Gourd',
      displayName: 'Bitter Gourd (Karawila)',
      localName: 'Karawila',
      category: SeasonalFoodCategory.vegetable,
      availableMonths: [1, 2, 3, 4, 5, 9, 10, 11],
      emoji: '🥒',
      description: 'A bitter vegetable frequently used in Sri Lankan meals.',
      nutritionTags: [
        'Vitamin C',
        'Low Calorie',
      ],
      healthBenefits: [
        'Supports a balanced diet',
      ],
    ),

    SeasonalFood(
      id: 'okra',
      name: 'Okra',
      displayName: 'Okra (Bandakka)',
      localName: 'Bandakka',
      category: SeasonalFoodCategory.vegetable,
      availableMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      emoji: '🥬',
      description: 'A green vegetable commonly used in curries and stir-fries.',
      nutritionTags: [
        'High Fiber',
        'Folate',
      ],
      healthBenefits: [
        'Supports digestion',
      ],
    ),

    SeasonalFood(
      id: 'jackfruit',
      name: 'Jackfruit',
      displayName: 'Young Jackfruit (Polos)',
      localName: 'Polos',
      category: SeasonalFoodCategory.vegetable,
      availableMonths: [3, 4, 5, 6, 7, 8],
      emoji: '🟢',
      description: 'Young jackfruit is commonly cooked as a Sri Lankan curry.',
      nutritionTags: [
        'High Fiber',
        'Carbohydrates',
      ],
      healthBenefits: [
        'Provides energy',
        'Supports digestion',
      ],
    ),

    // Fish and proteins

    SeasonalFood(
      id: 'tuna',
      name: 'Tuna',
      displayName: 'Tuna (Kelawalla)',
      localName: 'Kelawalla',
      category: SeasonalFoodCategory.fish,
      availableMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
      emoji: '🐟',
      description: 'A popular fish used in Sri Lankan curries and grilled meals.',
      nutritionTags: [
        'High Protein',
        'Omega-3',
      ],
      healthBenefits: [
        'Supports muscle maintenance',
        'Supports heart health',
      ],
    ),

    SeasonalFood(
      id: 'mackerel',
      name: 'Mackerel',
      displayName: 'Mackerel (Kumbalawa)',
      localName: 'Kumbalawa',
      category: SeasonalFoodCategory.fish,
      availableMonths: [1, 2, 3, 6, 7, 8, 9],
      emoji: '🐟',
      description: 'An oily fish containing protein and healthy fats.',
      nutritionTags: [
        'High Protein',
        'Omega-3',
      ],
      healthBenefits: [
        'Supports heart health',
      ],
    ),

    SeasonalFood(
      id: 'prawns',
      name: 'Prawns',
      displayName: 'Prawns (Isso)',
      localName: 'Isso',
      category: SeasonalFoodCategory.fish,
      availableMonths: [1, 2, 3, 4, 8, 9, 10, 11, 12],
      emoji: '🦐',
      description: 'A seafood protein commonly used in Sri Lankan curries.',
      nutritionTags: [
        'High Protein',
        'Low Carbohydrate',
      ],
      healthBenefits: [
        'Supports muscle maintenance',
      ],
    ),

    SeasonalFood(
      id: 'cowpea',
      name: 'Cowpea',
      displayName: 'Cowpea (Kawpi)',
      localName: 'Kawpi',
      category: SeasonalFoodCategory.protein,
      availableMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
      emoji: '🫘',
      description: 'A plant-based protein frequently used in Sri Lankan meals.',
      nutritionTags: [
        'Plant Protein',
        'High Fiber',
      ],
      healthBenefits: [
        'Supports digestion',
        'Supports muscle maintenance',
      ],
    ),
  ];
}