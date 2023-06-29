import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quicko/provider/product_provider.dart';

class GeneralScreen extends StatefulWidget {

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> _categoryList =[];

  _getCategories(){
    return _firestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _categoryList.add(doc['categoryName']);
        });
      });
    });
  }
  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(validator: (value){
                if(value!.isEmpty){
                  return "Enter product name";
                }else{
                  return null;
                }
              },
                onChanged: (value){
                  _productProvider.getFormData(productName:value);
                },
                decoration: InputDecoration(
                  labelText:'Enter product name',
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(validator: (value){
                if(value!.isEmpty){
                  return "Enter product price";
                }else{
                  return null;
                }
              },
                onChanged: (value){
                  _productProvider.getFormData(productPrice:double.parse(value));
                },
                decoration: InputDecoration(
                  labelText:'Enter product price',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20,),
              TextFormField(validator: (value){
                if(value!.isEmpty){
                  return "Enter product quantity";
                }else{
                  return null;
                }
              },
                onChanged: (value){
                  _productProvider.getFormData(productQuantity:int.parse(value));
                },
                decoration: InputDecoration(
                  labelText:'Enter product quanity',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20,),
              DropdownButtonFormField(

                  hint:Text('Select Category') ,
                  items: _categoryList.map<DropdownMenuItem<String>>((e){
                    return DropdownMenuItem(value: e,child: Text(e));
                  }).toList(),
                  onChanged: (value){
                    setState(() {

                      _productProvider.getFormData(category: value);
                    });
                  }
              ),
              SizedBox(height: 20,),
              TextFormField(validator: (value){
                if(value!.isEmpty){
                  return "Enter product description";
                }else{
                  return null;
                }
              },

                onChanged: (value){
                  _productProvider.getFormData(description:value);
                },
                maxLines: 10,
                maxLength: 200,
                decoration: InputDecoration(
                  labelText:('Enter product description'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
