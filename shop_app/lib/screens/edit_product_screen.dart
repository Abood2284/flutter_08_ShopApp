import 'package:flutter/material.dart';

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

/// * Always dispose your FocusNode to stop memeory Leak
  @override
  void dispose() {
    super.dispose();
    _priceNode.dispose();
    _descriptionNode.dispose();
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
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionNode,
                ),
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
                              child: Image.network(_imageUrl,
                                  fit: BoxFit.cover),
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
                        /// Will run on evry change you made so you without pressing done users gets the preview and thats good user Experience.
                        onChanged: (value) {
                          setState(() {
                            _imageUrl = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
