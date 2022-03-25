import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('MENU'),
            automaticallyImplyLeading: false,
          ), // Will disable the back button from the drawer
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pop;
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
              // Navigator.of(context).pushReplacement(CustomRoute(
              //   builder: (ctx) =>
              //       OrdersScreen(), // Explanation in ../helpers/custom_route.dar
              // ));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Manage products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              // Becuase hard reset/ change in widgets leads to error so before switching the state ot ui pop the unwanted UI becuase after this we are straight going to auth_screen
              Navigator.of(context).pop;
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
