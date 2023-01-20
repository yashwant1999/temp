class Product {
  final String id;

  final String name;
  final int cost;
  final int availibility;
  final String details;
  final String category;

  Product(
      {required this.id,
      required this.name,
      required this.cost,
      required this.availibility,
      required this.details,
      required this.category});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['p_id']?.toString() ?? '',
        name: json['p_name'] ?? '',
        cost: json['p_cost'] ?? 0,
        availibility: json['p_availibility'] ?? 0,
        details: json['p_details'] ?? 'null',
        category: json['p_category'] ?? 'null');
  }

  copyWith(
    String? id,
    String? name,
    int? cost,
    int? availibility,
    String? details,
    String? category,
  ) {
    return {
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      availibility: availibility ?? this.availibility,
      details: details ?? this.details,
      category: category ?? this.details,
    };
  }
}
