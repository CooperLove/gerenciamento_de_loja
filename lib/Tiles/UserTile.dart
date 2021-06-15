import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTile extends StatelessWidget {
  const UserTile(this._user, {Key key}) : super(key: key);

  final Map<String, dynamic> _user;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white);
    if (_user.containsKey("moneySpent"))
      return ListTile(
        title: Text(
          _user["name"],
          style: textStyle,
        ),
        subtitle: Text(
          _user["email"],
          style: textStyle,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Pedidos ${_user["numOrders"]}",
              style: textStyle,
            ),
            Text(
              "Gasto R\$ ${_user["moneySpent"].toStringAsFixed(2)}",
              style: textStyle,
            ),
          ],
        ),
      );
    else
      return _shimmer();
  }

  Widget _shimmer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            height: 20,
            child: Shimmer.fromColors(
                child: Container(
                  color: Colors.white.withAlpha(50),
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                ),
                baseColor: Colors.white,
                highlightColor: Colors.grey),
          ),
          SizedBox(
            width: 50,
            height: 20,
            child: Shimmer.fromColors(
                child: Container(
                  color: Colors.white.withAlpha(50),
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                ),
                baseColor: Colors.white,
                highlightColor: Colors.grey),
          )
        ],
      ),
    );
  }
}
