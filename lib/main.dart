import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting
        // the app, try changing the primarySwatch below to Colors.green
        // and then invoke "hot reload" (press "r" in the console where
        // you ran "flutter run", or press Run > Hot Reload App in
        // IntelliJ). Notice that the counter didn't reset back to zero;
        // the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful,
  // meaning that it has a State object (defined below) that contains
  // fields that affect how it looks.

  // This class is the configuration for the state. It holds the
  // values (in this case the title) provided by the parent (in this
  // case the App widget) and used by the build method of the State.
  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isBusy = false;
  final List<Post> _posts = new List();
  final List<Photo> _photos = new List();
  final List<User> _users = new List();

  _MyHomePageState() {
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _isBusy
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : new ListView.builder(
              itemCount: _users.length,
              itemBuilder: (_, index) => new UserListItem(_users[index]),
            ),
      floatingActionButton: new FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: () {
            _refreshData();
          }),
    );
  }

  Future _refreshData() async {
    setState(() => _isBusy = true);

    var client = createHttpClient();
    var response =
        await client.get('https://jsonplaceholder.typicode.com/users');
    List users = JSON.decode(response.body);

    setState(() {
      _users.clear();
      _users.addAll(
          users.map((map) => new User(map['name'], map['email'], map['phone'], map['website'])).toList());

      _isBusy = false;
    });
  }
}

class User {
  final String name;
  final String email;
  final String phone;
  final String website;

  User(this.name, this.email, this.phone, this.website);
}

class UserListItem extends StatelessWidget {
  final User user;

  UserListItem(this.user);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: new Text(
              user.name,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.display1.copyWith(color: Colors.black87),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.email),
            title: new Text(user.email),
          ),
          new ListTile(
            leading: const Icon(Icons.phone),
            title: new Text(user.phone),
          ),
          new ListTile(
            leading: const Icon(Icons.web),
            title: new Text(user.website),
          ),
        ],
      ),
    );
  }
}


class Photo {
  final String url;
  final String title;

  Photo(this.title, this.url);
}

class PhotoItem extends StatelessWidget {
  final Photo photo;

  PhotoItem(this.photo);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new SizedBox.fromSize(
        size: const Size.fromHeight(200.0),
        child: new Image.network(photo.url),
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  PostItem(this.post);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        showDialog(
          context: context,
          child: new AlertDialog(
            title: const Text('Item tapped'),
            content: new Text(post.title),
            actions: <Widget>[
              new FlatButton(onPressed: null, child: const Text('OK'))
            ],
          ),
        );
      },
      child: new ListTile(
        isThreeLine: false,
        title: new Text(
          post.title,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: new Text(
          post.body,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }
}

class Post {
  Post(this.title, this.body);

  final String title;
  final String body;
}
