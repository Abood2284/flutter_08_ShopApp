import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

import '../model/product.dart';
import '../providers/products.dart';
import '../constants.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product-screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // To switch from title field to price
  final _priceNode = FocusNode();
  // To switch from price field to description field
  final _descriptionNode = FocusNode();

  /// * This focus is not for shifting focus but to check if this field is having focus or not
  /// so that i can setState and show the upadate the image preview
  ///
  /// Also i need to check if the focus is on the field or not so to check this the place will be initState
  /// (Can only be used if you are using the controller approach, though here we dont neeed controller as in FLutter 2 onChanged method was added which stored every change and reflect it the same time)
  final _imageUrlFocus = FocusNode();

  // This key is used so that form widget state can be accesed from outside the build
  // Its a generic type so we can say what type of data we are expecting
  final _saveFormKey = GlobalKey<FormState>();

  // This is the empty product object we will use, since we added copyWith method in our privider class we can replace this product values with new one without creating new objects.
  // This object will be saved when saveForm is called
  var _editedProduct = Product(
    id: DateTime.now().toString(),
    title: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );
  // This will be the _initValues for all the text fields that is empty string, if we have product then we replace this map with filled values in didChangeDependencies
  // else we use the empty values
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  // now didChangeDependencies are executed several times while the screen is open,
  // so to run this once we will create a bool
  var _intiRun = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_intiRun) {
      // Added ? can be null operator becoz if we press add icon this will still run without args -> error saying Null cannot by SubType of string
      var productId = ModalRoute.of(context)!.settings.arguments as String?;
      // As i said earlier this method runs several times when the page is open, and this page will also open if i press the add product button. though we are not pasing there arguments hence this might throw an error, so we want to continue if we have a product
      if (productId != null) {
        //  with that we get our product we are looking for
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
            // Now replace the empty strings on the text field with Prodcut values
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price
              .toString(), // Because TexField takes String only, we have to parsse it int later or double
          'description': _editedProduct.description,
          'imageUrl': _editedProduct.imageUrl,
        };
        // Now if we came here using the add button above code will not run as it will not find the product id, and initialValue map will have empty strings now which can be assigned to textfields
      }
    }
    _intiRun = false;
  }

  /// * Always dispose your FocusNode to stop memeory Leak
  @override
  void dispose() {
    super.dispose();
    _priceNode.dispose();
    _descriptionNode.dispose();
  }

  /// * This will save our form
  ///
  /// Now to get access to form WIdget from inside class we need to use {GLOBAL KEY}
  /// after creating a final global key then add it to your form, then you can use it here
  void _saveForm() {
    /// * And this will activate all the Validators of the fields... though you could also add autoValidation =true which will validate on every key stroke,
    ///
    /// Here is another thing validate() returns true if all the validators returned null, if any one of the validator return a String/error it validate will return false
    ///
    /// hence is validate is true then only save the form
    final validationResult = _saveFormKey.currentState!.validate();
    if (!validationResult) {
      return; // ! Below code will not run if this validationResult == false
    }
    // * Save() will trigger onSave method one every field of form which allows you take the value entered in it and do whatever you want(i.e: store it into a global map that stores all the text inputs)
    // However here we are going to create a mutable method for products so that we can edit it for every field we have. for tht first add the onSaved: on all fields
    _saveFormKey.currentState!.save();
    // Once the form is saved now pass the object to add new product to list
    // Also setting listen to false because dont want to listen to actions i just want to dispatch and action.
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    // After saving i want to pop the screen
    Navigator.of(context).pop();
  }

  /// * Instead of using this you can also use the normal Expression like string.endsWith(http) or not ends with jpg or not
  /// This Regx was copied from google from my flutter course, you dont need to learn this, it was specially used in javaScript
  /// for complex sorting
  ///
  /// Read about Regx -> https://api.dart.dev/stable/2.13.4/dart-core/RegExp-class.html
  String? _imageValidator(String value) {
    const urlPattern =
        r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    final result = RegExp(urlPattern, caseSensitive: false).firstMatch(value);

    if (result == null) {
      return 'Please enter a valid URL.';
    }

    final String smallCaps = value.toLowerCase();
    final bool isAllowedExtension = smallCaps.endsWith('.png') ||
        smallCaps.endsWith('.jpg') ||
        smallCaps.endsWith('.jpeg');
    if (!isAllowedExtension) {
      return 'Please enter an image URL (png or jpg)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // logger.d(_initValues['imageUrl']);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Form(
          key: _saveFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    // value refers to String on the field, provided by flutter
                    if (value!.isEmpty) {
                      return 'Please Provide a title';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    // Change the mouse focus to next FocusNode
                    FocusScope.of(context).requestFocus(_priceNode);
                  },
                  // This is triggred from up the widget tree where .save is called on form key
                  onSaved: (value) {
                    /* There are many ways to do this
                    
                     2: you can also create local variables
                    
                     String _title;
                     double _price;
                     String _description
                     Then for all but the imageUrl's field's onSave method, I assigned the value to the variable.
                    
                     onSaved: (v)=>_price = double.parse(v),
                    
                     AT LAST WHERE YOU WANT TO SAVE (SAVE METHOD)
                     onSaved: (v){
                       _editedProduct = Product(
                         id: DateTime.now().toString(),
                         title: _title,
                         price: _price,
                         description: _description,
                         imageUrl: v
                       );
                     },
                     */
                    _editedProduct = _editedProduct.copyWith(title: value);
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'],
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the price';
                    }
                    // .tryParse returns null if it faces a non valid number
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter the price greater than 0';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    // Change the mouse focus to next FocusNode
                    FocusScope.of(context).requestFocus(_descriptionNode);
                  },
                  onSaved: (value) {
                    _editedProduct =
                        _editedProduct.copyWith(price: double.parse(value!));
                  },
                ),
                TextFormField(
                    initialValue: _initValues['description'],
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      if (value.length < 10) {
                        return 'Should be atleast 10 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct =
                          _editedProduct.copyWith(description: value);
                    }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(
                        top: 10,
                        right: 13,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                      ),
                      // If url is empty show text else the image
                      child: _initValues['imageUrl']!.isEmpty
                          ? const Text('Enter Url')
                          : FittedBox(
                              child: Image.network(
                                  _initValues['imageUrl'] as String,
                                  fit: BoxFit.cover),
                            ),
                    ),
                    // ! Wrapped in expanded becoz TextFormField takes infinite widht and with row = error
                    Expanded(
                      child: TextFormField(
                          initialValue: _initValues['imageUrl'],
                          decoration:
                              const InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          focusNode: _imageUrlFocus,
                          validator: (value) {
                            _imageValidator(value!);
                          },

                          /// * So that we load the updated image entered by the user
                          ///
                          /// Will run on every change you made so you without pressing done users gets the preview and thats a good user Experience.
                          onChanged: (value) {
                            setState(() {
                              _initValues['imageUrl'] = value;
                            });
                          },
                          onSaved: (value) {
                            _editedProduct =
                                _editedProduct.copyWith(imageUrl: value);
                          }),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(top: 10),
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
