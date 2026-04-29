import 'dart:isolate';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class TokenManager extends GetxController{
  //Token
  final storage =  const FlutterSecureStorage();

  String? globalToken;
  String? userId;
  String? phone;
  String? role;
  String? fullName;
  String? photo;

  setToken({required String token,})async{
    globalToken = token;
    await storage.write(key: 'token', value: token);
    update();
  }

  setPhoto({required String ph,})async{
    photo = ph;
    await storage.write(key: 'photo', value: ph);
    update();
  }



  setUserId({required String? id})async{
    userId = id;
    await storage.write(key: 'userId', value: id);
    update();
  }

  setUserPhone({required String? phoneNo})async{
    phone = phoneNo;
    await storage.write(key: 'phone', value: phoneNo);
    update();
  }

  setUserRole({required String? userRole})async{
    role = userRole;
    await storage.write(key: 'role', value: userRole);
    update();
  }

  setUserFullName({required String? name})async{
    fullName = name;
    await storage.write(key: 'fullName', value: name);
    update();
  }

//Get Token from Storage and Make it global
  Future<String?> getToken()async{
    if(globalToken != null){
      return globalToken;
    }else{
      globalToken = await storage.read(key: 'token');
    }
    update();
    return globalToken;
  }

//Get User Id from Storage and Make it global
  getUserId()async{
    if(userId != null){
      return userId;
    }else{
      userId = await storage.read(key: 'userId');
    }
    update();
    return userId;

  }

  getPhone()async{
    if(phone!= null){
      return phone;
    }else{
      phone = await storage.read(key: 'phone');
    }
    update();
    return phone;
  }

  getPhoto()async{
    if(photo!= null){
      return photo;
    }else{
      photo = await storage.read(key: 'photo');
    }
    update();
    return photo;
  }

  Future<String?> getUserRole()async{
    if(role!= null){
      return role;
    }else{
      role = await storage.read(key: 'role');
    }
    update();
    return role;
  }

   getFullName()async{
    if(fullName != null){
      return fullName;
    }else{
      fullName = await storage.read(key: 'fullName');
    }
    update();
    return fullName;
  }


  logout()async{
    await storage.deleteAll();
     globalToken= null;
     userId= null;
     phone= null;
     role= null;
     fullName= null;
     photo= null;
    update();
  }

}