
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/models/user_model.dart';

class UserNotifier  extends Notifier<List<User>>{

  @override
  List<User> build() {
    return [];
  }

  void addUser(User user) {
    state = [...state,user];
  }

}


final userProvider = NotifierProvider<UserNotifier ,List<User> >(UserNotifier .new);

