import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/models/user_model.dart';
import 'package:riverpod_learning/providers/user_provider.dart';

class UserForm extends ConsumerStatefulWidget {
  const UserForm({super.key});

  @override
  ConsumerState<UserForm> createState() => _UserFormState();
}

class _UserFormState extends ConsumerState<UserForm> {

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final momController = TextEditingController();
  final dadController = TextEditingController();
  final stateController = TextEditingController();


  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    momController.dispose();
    dadController.dispose();
    stateController.dispose();
    super.dispose();
  }

  void submitUser () {
    final users = User(
        name: nameController.text,
        phoneNo: phoneController.text,
        mom: momController.text,
        dad: dadController.text,
        state: stateController.text
    );

    ref.read(userProvider.notifier).addUser(users);

    nameController.clear();
    phoneController.clear();
    momController.clear();
    dadController.clear();
    stateController.clear();
  }


  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        TextField(
          controller:nameController ,
          decoration: const InputDecoration(hintText: 'name'),
        ),
        TextField(
          controller:phoneController ,
          decoration: const InputDecoration(hintText: 'phone number'),
        ),
        TextField(
          controller:momController ,
          decoration: const InputDecoration(hintText: 'mother name'),
        ),
        TextField(
          controller:dadController ,
          decoration: const InputDecoration(hintText: 'father name'),
        ),
        TextField(
          controller:stateController ,
          decoration: const InputDecoration(hintText: 'state'),
        ),


        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: submitUser,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}