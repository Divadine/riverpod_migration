class Car {
  final String id;
  final String name;      // shown on the card, e.g. "Maruti Suzuki Wagon R"
  final String brand;     // "Maruti"
  final String model;     // "Wagon R", must match the names in the filter sheet
  final String bodyType;  // SUV / Sedan / Van / MUV
  final String variant;   // Automatic / Manual
  final String fuel;      // Petrol / Diesel / CNG / Hybrid / Electric
  final int price;        // in rupees
  final int mileage;      // km
  final int engineCc;
  final double rating;    // 0 - 5

  const Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.bodyType,
    required this.variant,
    required this.fuel,
    required this.price,
    required this.mileage,
    required this.engineCc,
    required this.rating,
  });
}