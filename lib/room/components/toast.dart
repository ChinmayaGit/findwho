import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';

customToast({
  required String msg,required context
}){
  return GFToast.showToast(
    msg,
    context,
    toastPosition: GFToastPosition.BOTTOM,
    textStyle: TextStyle(fontSize: 16, color: GFColors.WHITE),
    backgroundColor: GFColors.DARK,
    trailing: Icon(
      Icons.close,
      color: GFColors.SUCCESS,
    ),);
}
