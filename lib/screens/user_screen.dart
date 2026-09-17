import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/widgets/user_form.dart';

import '../providers/user_provider.dart' show userProvider;

class UserScreen extends ConsumerWidget{
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){

    final users = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(title: Text('User Details',style: TextStyle(color: Colors.red,fontSize: 18),),),

      body: Column(
        children: [

          UserForm(),
          Divider(),

          Expanded(
              child:ListView.builder(
                itemCount: users.length,
                  itemBuilder: (context,index){
                  final user = users[index];

                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(
                        '${user.phoneNo}\n'
                            'Mom: ${user.mom}\n'
                            'Dad: ${user.dad}\n'
                            'State: ${user.state}'
                    ),
                  );
                  }
              )
          ),
        ],
      ),
    );
  }
}