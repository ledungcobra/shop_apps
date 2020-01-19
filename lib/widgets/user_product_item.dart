import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  //const UserProductItem({Key key}) : super(key: key);
  static const String nameRoute = '/UserProductItem';
  final String id;
  final String imageUrl;
  final String title;

  UserProductItem(this.id, this.title, this.imageUrl);
  Future<void> _removeProduct(String id, BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false)
          .removeProduct(id);
    } catch (e) {
     
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Error"),
      ));
      showDialog(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
                  actions: <Widget>[
                    CupertinoButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        Navigator.pop(context);
                       
                      },
                    )
                  ],
                ));

      // print('loi');
      // await showDialog(
      //   context: context,
      //   child: Text('Network error'),
      //   builder: (ctx) => AlertDialog(
      //     title: Text('Error'),
      //     actions: <Widget>[
      //       CupertinoButton(

      //         child: Text('Yes'),
      //         onPressed: () {
      //           Navigator.of(ctx).pop();
      //         },
      //       )
      //     ],
      //   ),
      // ).then((_){
      //   print('Complete');
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.title,
      ),
      leading: CircleAvatar(
        child: Image.network(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.nameRoute, arguments: id);
              },
            ),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () => _removeProduct(id, context)),
          ],
        ),
      ),
      // trailing: Row(
      //   children: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.delete,color: Theme.of(context).errorColor,),
      //       onPressed: () {},
      //     ),
      //     IconButton(
      //       icon: Icon(Icons.edit,color: Theme.of(context).primaryColor),
      //       onPressed: () {},
      //     )
      //   ],
      // ),
    );
  }
}
