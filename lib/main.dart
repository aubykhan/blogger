import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Steps
/// 1. New application.
/// 2. Change theme, title etc.
/// 3. Add listView with refresh button (fab).
/// 4. Use simple static data to populate the list.
/// 5. Add http package
/// 6. Create http client and call service to update the list.
/// 7. Enhance UI, add cards etc.
/// 8. Add loader.

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Awesome user list',
      theme: new ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.red,
      ),
      home: new MyHomePage(title: 'Awesome user list'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<UserListTile> _listTiles = new List();
  bool _isLoading = true;

  _MyHomePageState() {
    _refreshData();
  }

  Future _refreshData() async {
    setState(() {
      _isLoading = true;
      _listTiles.clear();
    });

    var client = createHttpClient();
    var response =
        await client.get('https://jsonplaceholder.typicode.com/users');
    List list = JSON.decode(response.body);

    setState(() {
      _isLoading = false;
      _listTiles.addAll(list.map((item) => new UserListTile(new User(
            item['name'],
            item['email'],
            item['phone'],
            item['website'],
          ))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _isLoading
          ? new Center(child: const CircularProgressIndicator())
          : new ListView(
              children: ListTile
                  .divideTiles(
                    context: context,
                    tiles: _listTiles,
                  )
                  .toList(),
            ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _refreshData,
        tooltip: 'Refresh',
        child: new Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class User {
  final String name;
  final String email;
  final String phone;
  final String website;

  User(this.name, this.email, this.phone, this.website);
}

class UserListTile extends StatelessWidget {
  final User user;

  UserListTile(this.user);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new ListTile(
            title: new Text(
              user.name,
              style: Theme.of(context).textTheme.display1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          new ListTile(
            title: new Text(user.email),
            leading: const Icon(Icons.email),
          ),
          new ListTile(
            title: new Text(user.phone),
            leading: const Icon(Icons.phone),
          ),
          new ListTile(
            title: new Text(user.website),
            leading: const Icon(Icons.web),
          ),
        ],
      ),
    );
  }
}
