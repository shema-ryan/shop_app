import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../provider/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final TextEditingController _imgUrlController = TextEditingController();
  final FocusNode _imageUrlFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String title = 'New Product';
  bool isLoading = false;
  Product editedProduct = Product(
    price: 0,
    title: '',
    id: null,
    description: '',
    imageUrl: '',
  );
  bool isInt = true;
  Map<String, dynamic> initialValue = {
    'title': '',
    'description': '',
    'price': 0.0,
    'imageUrl': '',
  };
  @override
  void initState() {
    _imageUrlFocus.addListener(_updateListener);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocus.removeListener(_updateListener);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imgUrlController.dispose();
    _imageUrlFocus.dispose();
    super.dispose();
  }

  void _updateListener() {
    if (!_imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (editedProduct.id != null) {
        setState(() {
          isLoading = true;
        });
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(editedProduct.id, editedProduct);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(editedProduct)
            .catchError((error) {
          return showDialog<Null>(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('something went wrong'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
        }).then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (isInt) {
      final String productId =
          ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .items
            .firstWhere((element) => element.id == productId);
        title = 'Edit Product';
        initialValue = {
          'title': editedProduct.title,
          'description': editedProduct.description,
          'price': editedProduct.price.toString(),
        };
        _imgUrlController.text = editedProduct.imageUrl;
      }
    }
    isInt = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
        elevation: 0.0,
        centerTitle: true,
        title: Text(title),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: initialValue['title'],
                      validator: (text) {
                        if (text.isEmpty) {
                          return 'hello there';
                        }
                        return null;
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: 'Title'),
                      onFieldSubmitted: (text) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                          imageUrl: editedProduct.imageUrl,
                          title: value,
                          description: editedProduct.description,
                          id: editedProduct.id,
                          price: editedProduct.price,
                          isFavorite: editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initialValue['price'].toString(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid amount ';
                        }
                        if (double.parse(value) <= 2) {
                          return 'amount greater than 2 ';
                        }
                        return null;
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (text) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      decoration: InputDecoration(
                        labelText: 'price',
                      ),
                      onSaved: (value) {
                        editedProduct = Product(
                          imageUrl: editedProduct.imageUrl,
                          title: editedProduct.title,
                          description: editedProduct.description,
                          id: editedProduct.id,
                          isFavorite: editedProduct.isFavorite,
                          price: double.parse(value),
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initialValue['description'],
                      validator: (value) {
                        if (value.isEmpty || value.length < 10) {
                          return 'Empty or short description';
                        }
                        return null;
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      maxLines: 4,
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      onSaved: (value) {
                        editedProduct = Product(
                          imageUrl: editedProduct.imageUrl,
                          title: editedProduct.title,
                          description: value,
                          id: editedProduct.id,
                          isFavorite: editedProduct.isFavorite,
                          price: editedProduct.price,
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: _imgUrlController.text.isEmpty
                              ? Text('enter image url')
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network(
                                    _imgUrlController.text,
                                  ),
                                ),
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (!value.startsWith('http') ||
                                  !value.startsWith('https')) {
                                return 'no valid URL';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              editedProduct = Product(
                                imageUrl: value,
                                title: editedProduct.title,
                                description: editedProduct.description,
                                id: editedProduct.id,
                                isFavorite: editedProduct.isFavorite,
                                price: editedProduct.price,
                              );
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                            focusNode: _imageUrlFocus,
                            controller: _imgUrlController,
                            cursorColor: Theme.of(context).primaryColor,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: 'image URL',
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
