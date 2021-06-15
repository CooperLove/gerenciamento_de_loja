import 'package:flutter/material.dart';
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
        body: PageView(
          controller: _pageController,
          onPageChanged: (p) {
            setState(() {
              _currentPage = p;
            });
          },
          children: [
            UsersTab(),
            Container(
              color: Colors.blueAccent,
            ),
            Container(
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
