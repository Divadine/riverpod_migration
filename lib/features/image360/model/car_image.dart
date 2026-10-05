class CarImage {
  final String id;
  final String name;
  final String panoramaImage;

  const CarImage({
    required this.id,
    required this.name,
    required this.panoramaImage,
  });

  factory CarImage.fromJson(Map<String, dynamic> json) {
    return CarImage(
      id: json['id'],
      name: json['name'],
      panoramaImage: json['panorama_image'],
    );
  }
}