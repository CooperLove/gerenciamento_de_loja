import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_de_loja/Blocs/OrdersBloc.dart';
import 'package:gerenciamento_de_loja/Blocs/UserBloc.dart';
import 'package:gerenciamento_de_loja/Tabs/OrdersTab.dart';
import 'package:gerenciamento_de_loja/Tabs/UsersTab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          onTap: (p) {
            _pageController.animateToPage(p,
                duration: Duration(milliseconds: 250), curve: Curves.ease);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Clientes"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: "Pedidos"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Produtos"),
          ],
        ),
        body: BlocProvider(
          blocs: [Bloc((i) => UserBloc()), Bloc((i) => OrdersBloc())],
          dependencies: [],
          child: PageView(
            controller: _pageController,
            onPageChanged: (p) {
              setState(() {
                _currentPage = p;
              });
            },
            children: [
              UsersTab(),
              OrdersTab(),
              Container(
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
