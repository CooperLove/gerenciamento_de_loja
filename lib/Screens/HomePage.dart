import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerenciamento_de_loja/Blocs/CategoryBloc.dart';
import 'package:gerenciamento_de_loja/Blocs/OrdersBloc.dart';
import 'package:gerenciamento_de_loja/Blocs/UserBloc.dart';
import 'package:gerenciamento_de_loja/Screens/ProductsTab.dart';
import 'package:gerenciamento_de_loja/Tabs/OrdersTab.dart';
import 'package:gerenciamento_de_loja/Tabs/UsersTab.dart';
import 'package:gerenciamento_de_loja/Widgets/EditCategoryDialogue.dart';

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
              ProductsTab(),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    final primaryColor = Theme.of(context).primaryColor;
    switch (_currentPage) {
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: primaryColor,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_downward,
                  color: primaryColor,
                ),
                backgroundColor: Colors.white,
                label: "Concluídos abaixo",
                labelBackgroundColor: Colors.white,
                onTap: () {
                  BlocProvider.getBloc<OrdersBloc>()
                      .setOrderCriteria(SortCriteria.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: primaryColor,
                ),
                backgroundColor: Colors.white,
                label: "Concluídos Acima",
                labelBackgroundColor: Colors.white,
                onTap: () {
                  BlocProvider.getBloc<OrdersBloc>()
                      .setOrderCriteria(SortCriteria.READY_FIRST);
                }),
          ],
        );
      case 2:
        return FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => EditCategoryDialogue(
                      categoryBloc: CategoryBloc(null),
                    ));
          },
          child: Icon(Icons.add),
        );
      default:
        return null;
    }
  }
}
