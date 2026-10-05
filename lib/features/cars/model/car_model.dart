class CarModel {
  final String id;
  final String brand;
  final String name;
  final String image; // asset path or network url
  final double rating;
  final String price;
  final String fuel;
  final String km;
  final String seats;
  final String? cc; // detailed card only
  final String? gear; // detailed card only
  final String? launchDate; // upcoming card only

  const CarModel({
    required this.id,
    required this.brand,
    required this.name,
    required this.image,
    this.rating = 5,
    this.price = '',
    this.fuel = 'Petrol',
    this.km = '12Km',
    this.seats = '5 persons',
    this.cc,
    this.gear,
    this.launchDate,
  });
}