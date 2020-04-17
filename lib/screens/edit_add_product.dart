import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditAddProduct extends StatefulWidget {
  static const routeName = '/edit-add-product';

  @override
  _EditAddProductState createState() => _EditAddProductState();
}

class _EditAddProductState extends State<EditAddProduct> {
  final priceNode = FocusNode();
  final descNode = FocusNode();
  final imageController = TextEditingController();
  final imageNode = FocusNode();
  final form = GlobalKey<FormState>();
  var editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var isLoading = false;

  var isInit = true;

  var initValue = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    imageNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        editedProduct = Provider.of<ProductsProv>(context, listen: false)
            .findById(productId);
        initValue = {
          'title': editedProduct.title,
          'price': editedProduct.price.toString(),
          'description': editedProduct.description,
          'imageUrl': '',
        };
        imageController.text = editedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageNode.removeListener(updateImageUrl);
    priceNode.dispose();
    imageNode.dispose();
    descNode.dispose();
    imageController.dispose();
    super.dispose();
  }

  void updateImageUrl() {
    if (!imageNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> saveForm() async {
    final isValid = form.currentState.validate();
    if (!isValid) {
      return;
    }
    form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (editedProduct.id != null) {
      await Provider.of<ProductsProv>(context, listen: false)
          .updateProduct(editedProduct.id, editedProduct);
    } else {
      try {
        await Provider.of<ProductsProv>(context, listen: false)
            .addProducts(editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Something went wrong'),
            content: Text('Error'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'))
            ],
          ),
        );
      } 
      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveForm,
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: initValue['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(priceNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                          title: value,
                          price: editedProduct.price,
                          description: editedProduct.description,
                          imageUrl: editedProduct.imageUrl,
                          id: editedProduct.id,
                          isFavourite: editedProduct.isFavourite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initValue['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: priceNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(descNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Provide a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Enter number > 0';
                        }
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                          title: editedProduct.title,
                          price: double.parse(value),
                          description: editedProduct.description,
                          imageUrl: editedProduct.imageUrl,
                          id: editedProduct.id,
                          isFavourite: editedProduct.isFavourite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initValue['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: descNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Provide a description';
                        }
                        if (value.length < 10) {
                          return 'Should be greater than 10 chars';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                          title: editedProduct.title,
                          price: editedProduct.price,
                          description: value,
                          imageUrl: editedProduct.imageUrl,
                          id: editedProduct.id,
                          isFavourite: editedProduct.isFavourite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          width: 100,
                          height: 100,
                          child: imageController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(imageController.text,
                                      fit: BoxFit.cover),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: imageController,
                            focusNode: imageNode,
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return 'Provide a value';
                            //   }
                            //   if (!value.startsWith('http') &&
                            //       !value.startsWith('https')) {
                            //     return 'Enter valid URL';
                            //   }
                            //   if (!value.endsWith('.png') &&
                            //       !value.endsWith('jgp') &&
                            //       !value.endsWith('jpeg')) {
                            //     return 'Enter valid image';
                            //   }
                            //   return null;
                            // },
                            onSaved: (value) {
                              editedProduct = Product(
                                title: editedProduct.title,
                                price: editedProduct.price,
                                description: editedProduct.description,
                                imageUrl: value,
                                id: editedProduct.id,
                                isFavourite: editedProduct.isFavourite,
                              );
                            },
                            onFieldSubmitted: (_) {
                              saveForm();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
