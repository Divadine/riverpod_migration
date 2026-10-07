import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/shared_widgets/asset_images.dart';

import '../model/car_model_item.dart';
import '../model/car_type_item.dart';




const _types = [
  CarTypeItem(
    id: '1',
    name: 'Hatchbacks',
    image: AssetImages.loginImage,
  ),

  CarTypeItem(
    id: '2',
    name: 'Sedan',
    image: AssetImages.loginImage,
  ),

  CarTypeItem(
    id: '3',
    name: 'SUV',
    image: AssetImages.loginImage,
  ),

  CarTypeItem(
    id: '4',
    name: 'MUV',
    image: AssetImages.loginImage,
  ),

  CarTypeItem(
    id: '5',
    name: 'Super Luxury',
    image: AssetImages.loginImage,
  ),

  CarTypeItem(
    id: '6',
    name: 'Convertible',
    image: AssetImages.loginImage,
  ),
];




const _models = [

  // Hatchbacks
  CarModelItem(
    id: '1',
    typeId: '1',
    name: 'Alto K10',
  ),

  CarModelItem(
    id: '2',
    typeId: '1',
    name: 'S-Presso',
  ),

  CarModelItem(
    id: '3',
    typeId: '1',
    name: 'Celerio',
  ),

  CarModelItem(
    id: '4',
    typeId: '1',
    name: 'WagonR',
  ),

  CarModelItem(
    id: '5',
    typeId: '1',
    name: 'Swift',
  ),


  // Sedan
  CarModelItem(
    id: '6',
    typeId: '2',
    name: 'Dzire',
  ),

  CarModelItem(
    id: '7',
    typeId: '2',
    name: 'Honda City',
  ),

  CarModelItem(
    id: '8',
    typeId: '2',
    name: 'Verna',
  ),

  CarModelItem(
    id: '9',
    typeId: '2',
    name: 'Ciaz',
  ),

  CarModelItem(
    id: '10',
    typeId: '2',
    name: 'Virtus',
  ),

  CarModelItem(
    id: '11',
    typeId: '2',
    name: 'Slavia',
  ),


  // SUV
  CarModelItem(
    id: '12',
    typeId: '3',
    name: 'Brezza',
  ),

  CarModelItem(
    id: '13',
    typeId: '3',
    name: 'Creta',
  ),

  CarModelItem(
    id: '14',
    typeId: '3',
    name: 'Nexon',
  ),

  CarModelItem(
    id: '15',
    typeId: '3',
    name: 'Thar',
  ),

  CarModelItem(
    id: '16',
    typeId: '3',
    name: 'Fortuner',
  ),

  CarModelItem(
    id: '17',
    typeId: '3',
    name: 'Harrier',
  ),


  // MUV
  CarModelItem(
    id: '18',
    typeId: '4',
    name: 'Ertiga',
  ),

  CarModelItem(
    id: '19',
    typeId: '4',
    name: 'XL6',
  ),

  CarModelItem(
    id: '20',
    typeId: '4',
    name: 'Innova Crysta',
  ),

  CarModelItem(
    id: '21',
    typeId: '4',
    name: 'Carens',
  ),

  CarModelItem(
    id: '22',
    typeId: '4',
    name: 'Triber',
  ),


  // Super Luxury
  CarModelItem(
    id: '23',
    typeId: '5',
    name: 'Mercedes Maybach',
  ),

  CarModelItem(
    id: '24',
    typeId: '5',
    name: 'BMW 7 Series',
  ),

  CarModelItem(
    id: '25',
    typeId: '5',
    name: 'Audi A8',
  ),

  CarModelItem(
    id: '26',
    typeId: '5',
    name: 'Porsche Panamera',
  ),


  // Convertible
  CarModelItem(
    id: '27',
    typeId: '6',
    name: 'BMW Z4',
  ),

  CarModelItem(
    id: '28',
    typeId: '6',
    name: 'Mini Cooper',
  ),

  CarModelItem(
    id: '29',
    typeId: '6',
    name: 'Mustang Convertible',
  ),
];



// 3. CAR TYPES PROVIDER


final carTypesProvider = Provider<List<CarTypeItem>>((ref) {
  return _types;
});


// 4. SELECTED TYPE


class SelectedTypeNotifier extends Notifier<CarTypeItem?> {

  @override
  CarTypeItem? build() {
    return null;
  }

  void select(CarTypeItem id) {
    state = id;
  }

  void clear() {
    state = null;
  }
}


final selectedTypeProvider =NotifierProvider<SelectedTypeNotifier, CarTypeItem?>(SelectedTypeNotifier.new,);






// 5. ALL MODELS PROVIDER


final carModelsDataProvider =Provider<List<CarModelItem>>((ref) {

  return _models;
});


// 6. MODELS OF SELECTED TYPE


final carModelsProvider = Provider<List<CarModelItem>>((ref) {


  // Get selected type
  final selectedType =ref.watch(selectedTypeProvider);



  // If nothing is selected
  // return empty list
  if (selectedType == null) {
    return [];
  }


  // Get all models
  final allModels =ref.watch(carModelsDataProvider);



  // Filter models
  return allModels.where((model) {

    return model.typeId == selectedType.id;

  }).toList();
});



// 7. SELECTED MODEL


class SelectedModelNotifier extends Notifier<CarModelItem?> {


  @override
  CarModelItem? build() {

    // Watch selected type.
    //
    // If type changes,
    // this notifier rebuilds.
    ref.watch(selectedTypeProvider);

    // New type means
    // old model should be removed.
    return null;
  }


  void select(CarModelItem model) {
    state = model;
  }


  void clear() {
    state = null;
  }
}


final selectedModelProvider =
NotifierProvider<SelectedModelNotifier, CarModelItem?>(
  SelectedModelNotifier.new,
);