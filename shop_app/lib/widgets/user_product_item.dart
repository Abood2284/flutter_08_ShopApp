import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String image;

  UserProductItem(this.title, this.image);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(image),
      ),
      /// ! Because row takes infinite Wdith and trailing dont stop it resulting in out of the box render so to stop added a fixed width.
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                //..Edit the product
              },
            ),
            IconButton(
              onPressed: () {
                //..Delete the product
              },
              icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
            ),
          ],
        ),
      ),
    );
  }
}
