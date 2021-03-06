import 'package:flutter/material.dart';
import 'package:uber/tabPages/earning_tab.dart';
import 'package:uber/tabPages/home_tab.dart';
import 'package:uber/tabPages/profile_tab.dart';
import 'package:uber/tabPages/rating_tab.dart';


// notre ecran qui contient la barre de navigation inferieure
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics:const NeverScrollableScrollPhysics(),
        controller: tabController,
        // Pour la barre de navigation du bas,l'ordre (des 'children:const' et des 'items:const') est importante(les iconnes sur la barre et les pages qui doivent apparaitre quand on click dessus)
        children: const [
          // Les class qui ont été definis et importés depuis le dossiers tabPages
          HomeTabPage(),
          EarningsTabPage(),
          RatingTabPage(),
          ProfileTabPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const[

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label:"Acceuil" 
          ),

           BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label:"Gain" 
          ),

           BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label:"Note" 
          ),

           BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label:"Profil" 
          ),

        ],
        unselectedItemColor: Colors.white60,
        selectedItemColor: Colors.white,
        // couleur de la barre
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
        ),
    );
  }
}
