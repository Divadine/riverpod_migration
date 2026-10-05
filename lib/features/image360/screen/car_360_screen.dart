import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:riverpod_learning/features/image360/provider/car_notifier.dart';

class Car360Screen   extends ConsumerWidget {
  const Car360Screen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref){
    final carState = ref.watch(carImageNotifierProvider);


    return Scaffold(
      appBar: AppBar(
        title: Text('Car 360 degree',style: TextStyle(fontSize: 20,color: Colors.black),),
      ),
      body: carState.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              'Error: $error',
            ),
          );
        },
          data: (car) {
            return Column(
              children: [
                Expanded(
                  //height: 300,
                  child: PanoramaViewer(
                    zoom: 0.8,
                    minZoom: 0.1,
                  maxZoom: 2.0,
                    child: Image.network(
                      //width: double.infinity,
                      //height: 50,
                      car.panoramaImage,
                      fit: BoxFit.cover,
                      loadingBuilder:
                      (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },

                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'Unable to load 360° image',
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    car.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            );
          },



      ),
    );
  }
}