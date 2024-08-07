import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hayvonimuz/drawer.dart';
import 'package:hayvonimuz/elonjoylash.dart';
import 'package:hayvonimuz/myelon.dart';
import 'package:hayvonimuz/profile.dart';
import 'package:hayvonimuz/rasmtanlash.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: asosiy(),
    );
  }
}

class asosiy extends StatefulWidget {
  @override
  _asosiyState createState() => _asosiyState();
}

class _asosiyState extends State<asosiy> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ImageSelectionPage(),
    myelon(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: mydrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Lottie.asset(
            'rasmlar/car.json',
          ),
        ],
        title: Center(
            child: Text("Zoo Markt",
                style: TextStyle(
                    color: Colors.black, fontFamily: "zain", fontSize: 35))),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Asosiy',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled_solid),
            label: "E'lon Joylash",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            label: "Mening E'lonlarim",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_crop_circle),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'uyhayvoni';
  List<Map<String, dynamic>> data = [];
  bool isDataLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isDataLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://dash.vips.uz/api/13/2838/39388?turi=$selectedCategory'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          data = List<Map<String, dynamic>>.from(jsonData);
        });
      } else {
        throw Exception('Failed to load data from the API');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isDataLoading = false;
      });
    }
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      fetchData(); // Fetch data based on the new selected category
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[700],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.search),
                  hintText: 'Izlash',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryButton(
                    image: "rasmlar/catt.jpg",
                    label: 'Uy',
                    isSelected: selectedCategory == 'uyhayvoni',
                    onTap: () => _selectCategory('uyhayvoni'),
                  ),
                  CategoryButton(
                    image: "rasmlar/asasas.jpg",
                    label: 'Chorva',
                    isSelected: selectedCategory == 'chorva',
                    onTap: () => _selectCategory('chorva'),
                  ),
                  CategoryButton(
                    image: "rasmlar/bird.png",
                    label: 'Qushlar',
                    isSelected: selectedCategory == 'qush',
                    onTap: () => _selectCategory('qush'),
                  ),
                  CategoryButton(
                    image: "rasmlar/fish.png",
                    label: 'Suv',
                    isSelected: selectedCategory == 'suv',
                    onTap: () => _selectCategory('suv'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              isDataLoading
                  ? Center(child: CircularProgressIndicator())
                  : data.isEmpty
                      ? Container(
                          color: Colors.orange[700],
                          height: MediaQuery.of(context).size.height / 2,
                          child: Center(
                            child: Text(
                              "Hozircha Ma'lumot Yo'q",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          children: data
                              .map((item) => PetCard(
                                    rasmi: item['rasmi'] != null &&
                                            item['rasmi'].isNotEmpty
                                        ? (item['rasmi'].startsWith('http')
                                            ? item['rasmi']
                                            : 'https://dash.vips.uz/${item['rasmi']}')
                                        : 'https://via.placeholder.com/150',
                                    nomi: item['hayvonnomi'] ?? 'Unknown',
                                    narxi: item['narxi'] ?? 'Unknown',
                                    yoshi: item['yoshi'] ?? 'unknown',
                                    manzil: item['manzil'] ?? 'Unknown',
                                    soglik: item['soglik'] ?? 'Unknown',
                                    turi: item['turi'] ?? 'unknown',
                                  ))
                              .toList(),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String image;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    required this.image,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isSelected ? Colors.red : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ],
    );
  }
}

class PetCard extends StatelessWidget {
  final String rasmi;
  final String nomi;
  final String narxi;
  final String yoshi;
  final String soglik;
  final String manzil;
  final String turi;

  const PetCard(
      {required this.rasmi,
      required this.nomi,
      required this.narxi,
      required this.yoshi,
      required this.soglik,
      required this.manzil,
      required this.turi});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(15),
          //     bottomLeft: Radius.circular(15),
          //   ),
          //   child: Image.network(rasmi,
          //       width: 100, height: 100, fit: BoxFit.cover),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nomi: $nomi",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Yoshi: $yoshi",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Sog'ligi: $soglik",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("narxi: $narxi",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Manzil: $manzil",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
