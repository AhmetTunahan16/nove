import 'dart:io';
import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'nove',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 22, 46, 83)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}
//favoriler ve favori ekleme
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext(){
    current = WordPair.random();
    notifyListeners();
  }
  var favorites = <WordPair>[]; //wordpair yerine ürün eklenebilir
  
  void toggleFavorite(){
    if (favorites.contains(current)){
      favorites.remove(current);
    }
    else{
      favorites.add(current);
    }
    notifyListeners();
  }
}
//favori eklemenin sonu
//farklı sayfaları gösterme kodu
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 var selectedIndex = 0;
 
  @override
  Widget build(BuildContext context) {

Widget page;
switch (selectedIndex) {
  case 0:
  page = LoginPage();
    break;
  case 1:
    page = GeneratorPage();
    break;
  case 2:
    page = FavoritesPage();
    break;
  case 3:
    page = ForzaPage();
  default:
    throw UnimplementedError('no widget for $selectedIndex');
}
//farklı sayfaları göstermenin sonu
//navigasyon menüsü
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.car_crash),
                  label: Text('FH5 Screenshot'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState((){
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}
//navigasyon menüsünün sonu


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase,
        style: style,
        semanticsLabel: pair.asPascalCase
        ),
      ),
    );
  }
}

// ...
//favoriler sayfası yaratma
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}
//favoriler sayfası yaratmanın sonu
class ForzaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    	return MaterialApp(
	home: Scaffold(
            appBar: AppBar(
                title: const Text(
                    'Insert Image Example',
                ),
            ),
            body: Center(
                child: Column(
                    children: <Widget>[
                        SizedBox(height: 20,),
                        Image.asset('assets/Asset_1.png',
                         height: 200,
                         scale: 2.5,
                    ),
                        Image.asset('assets/Asset_1.png',
                         height: 400,
                         width: 400,
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
class LoginPage extends StatelessWidget {
  @override
  Widget build(buildContext) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'NOVE',
              style: TextStyle(
                fontSize: 35,
                color: Colors.teal,

                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Please Enter email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value) {},

                        validator: (value) {
                          return value!.isEmpty ? 'Please Enter Email' : null;
                        },
                      ),
                    ),
                    SizedBox(height: 30),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: ' Please Enter Password',
                          prefixIcon: Icon(Icons.password),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value) {},

                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please Enter Password'
                              : null;
                        },
                      ),
                    ),

                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        onPressed: () {
                         
                        },
                        color: Colors.teal,
                        textColor: Colors.white,
                        child: Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

