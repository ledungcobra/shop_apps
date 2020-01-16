import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  //EditProductScreen({Key key}) : super(key: key);
  static const String nameRoute = '/edit product screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _desciptionFocus = FocusNode();
  var _initValues = {
    'title': '',
    'desciption': '',
    'price': '',
    'imageUrl': ''
  };
  var _imageUrlController = TextEditingController();
  final _imageUrlFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isInit = true;

  Product _editedProduct;

  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id == null) {
        _editedProduct = Product(
          id: null,
          price: null,
          title: null,
          description: null,
          imageUrl: null,
          isFavorite: false,
        );
      } else {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(id);
        _initValues = {
          'title': _editedProduct.title,
          'desciption': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl
        };
        _imageUrlController =
            TextEditingController(text: _initValues['imageUrl']);
      }
      _isInit = false;
    }
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState

    _imageUrlFocus.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageUrlFocus.removeListener(_updateImageUrl);
    _priceFocus.dispose();
    _desciptionFocus.dispose();
    _imageUrlController.dispose();
    _imageUrlFocus.dispose();
    super.dispose();
  }

  String _updateImageUrl() {
    if (_imageUrlController.text.isEmpty) {
      return 'Please enter image url';
    }
    if (!_imageUrlController.text.startsWith('http') &&
        !_imageUrlController.text.startsWith('https')) {
      return 'Please check your Url';
    }
    if (!_imageUrlController.text.endsWith('.png') &&
        !_imageUrlController.text.endsWith('.jpg') &&
        !_imageUrlController.text.endsWith('.bmp') &&
        !_imageUrlController.text.endsWith('jpeg')) {
      return 'Please enter your valid URL in to text field';
    }
    if (!_imageUrlFocus.hasFocus) {
      setState(() {});
      return null;
    }
  }

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final id = ModalRoute.of(context).settings.arguments;
    if (id != null) {
      //Existing item;
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct);
      Navigator.pop(context);
      setState(() {
        _isLoading = false;
      });
    } else
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        
         await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Occur error'),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.block),
                      onPressed: () {
                        
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      } finally {
       
        setState(() {
          _isLoading = false;
        });
         Navigator.pop(context);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editting your product'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            )
          ],
        ),
        //Handle user input
        body: _isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                radius: 50,
              ))
            : _handleUserInputForm(context)
        // child: child,
        );
  }

  Form _handleUserInputForm(BuildContext context) {
    return Form(
      key: _form,
      child: ListView(
        children: <Widget>[
          TextFormField(
            initialValue: _initValues['title'],
            validator: (value) {
              if (value.isEmpty) {
                return 'Please input title';
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: Theme.of(context).textTheme.title),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_priceFocus);
            },
            onSaved: (value) {
              _editedProduct = Product(
                  title: value,
                  description: _editedProduct.description,
                  id: _editedProduct.id,
                  imageUrl: _editedProduct.imageUrl,
                  price: _editedProduct.price,
                  isFavorite: _editedProduct.isFavorite);
            },
          ),
          TextFormField(
            initialValue: _initValues['price'],
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            focusNode: _priceFocus,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_desciptionFocus);
            },
            onSaved: (value) {
              _editedProduct = Product(
                  title: _editedProduct.title,
                  description: _editedProduct.description,
                  id: _editedProduct.id,
                  imageUrl: _editedProduct.imageUrl,
                  price: double.parse(value),
                  isFavorite: _editedProduct.isFavorite);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter the price';
              }
              if (double.tryParse(value) == null) {
                return 'Input price again this is not number';
              }
              if (double.parse(value) == 0) {
                return 'Price is not equal to zero please check it out';
              }
              if (double.parse(value) < 0) {
                return 'Price is not negative number please check it out';
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: 'Price',
                labelStyle: Theme.of(context).textTheme.title),
          ),
          TextFormField(
            initialValue: _initValues['desciption'],
            focusNode: _desciptionFocus,
            maxLines: 4,
            minLines: 1,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.title,
                labelText: 'Description'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter the desciption';
              }
              if (value.length < 10) {
                return 'Please provide more description';
              }
              return null;
            },
            onSaved: (value) {
              _editedProduct = Product(
                  title: _editedProduct.title,
                  description: value,
                  id: _editedProduct.id,
                  imageUrl: _editedProduct.imageUrl,
                  price: _editedProduct.price,
                  isFavorite: _editedProduct.isFavorite);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: _imageUrlController.text.isEmpty
                    ? Text('Enter image URL')
                    : FittedBox(
                        child: Image.network(_imageUrlController.text),
                        fit: BoxFit.cover,
                      ),
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: 10, right: 10),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey)),
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    labelStyle: Theme.of(context).textTheme.title,
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageUrlController,
                  focusNode: _imageUrlFocus,
                  // initialValue: _initValues['imageUrl'],
                  onSaved: (value) {
                    _editedProduct = Product(
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        id: _editedProduct.id,
                        imageUrl: value,
                        price: _editedProduct.price,
                        isFavorite: _editedProduct.isFavorite);
                  },
                  validator: (value) {
                    return _updateImageUrl();
                  },
                  onFieldSubmitted: (value) {
                    _saveForm();
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
