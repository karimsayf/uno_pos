import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final GlobalKey<State> _loadingKey = GlobalKey<State>();

showLoadingIndicator(){
  showDialog(context: Get.context!, builder: (context) => CupertinoActivityIndicator(key:_loadingKey,color: Colors.white,),);
}

dismissLoadingIndicator(){
  if (_loadingKey.currentContext != null) {
    Navigator.of(_loadingKey.currentContext!).pop();  // Close the dialog only if it’s open
  }
}

class LoadingIndicator extends StatefulWidget {
  final Color? color;
  const LoadingIndicator({super.key,this.color});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return  CupertinoActivityIndicator(color: widget.color ??  Colors.grey);
  }
}
