import 'package:flutter/material.dart';

import '../model/product.dart';

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
  // final _imageURL = FocusNode();

  /// * This is an Empty string that will store the value of the URl,
  var _imageUrl = '';
  // This key is used so that form widget state can be accesed from outside the build
  // Its a generic type so we can say what type of data we are expecting
  final _saveFormKey = GlobalKey<FormState>();

  // late Product _editedProduct;
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );

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
    // * Save() will trigger method one every field of form which allows you take the value entered in it and do whatever you want(i.e: store it into a global map that stores all the text inputs)
    // However here we are going to create a mutable method for products so that we can edit it for every field we have. for tht first add the onSaved: on all fields
    _saveFormKey.currentState!.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
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
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    // Change the mouse focus to next FocusNode
                    FocusScope.of(context).requestFocus(_priceNode);
                  },
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Provide a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceNode,
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
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionNode,
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
                      child: _imageUrl.isEmpty
                          ? const Text('Enter Url')
                          : FittedBox(
                              child:
                                  Image.network(_imageUrl, fit: BoxFit.cover),
                            ),
                    ),
                    // ! Wrapped in expanded becoz TextFormField takes infinite widht and with row = error
                    Expanded(
                      child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          // focusNode: _imageURL,
                          /// * So that we load the updated image entered by the user
                          ///
                          /// Will run on every change you made so you without pressing done users gets the preview and thats a good user Experience.
                          onChanged: (value) {
                            setState(() {
                              _imageUrl = value;
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
