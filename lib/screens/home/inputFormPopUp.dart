import 'package:flutter/material.dart';

class InputFormPopUp{
  final BuildContext context;
  InputFormPopUp(this.context);

  
  //class to show dialogbox
void showFormInputDialog(){
  showDialog(
      context: context, 
      builder:(BuildContext context){
        return const AlertDialog(
          title: Text('Carefully enter your details'),
        );
      }

  );
}
}