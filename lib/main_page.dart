import 'package:dotnetapiflutter/createuser.dart';
import 'package:flutter/material.dart';
import 'package:dotnetapiflutter/api_hendler.dart';
import 'package:dotnetapiflutter/modle.dart';
import 'package:dotnetapiflutter/edit_page.dart';
import 'package:http/http.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  api_hendler apiHandler = api_hendler();
  late List<User> data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<User> fetchedData = await apiHandler.getUserData();
    setState(() {
      data = fetchedData;
    });
  }

  void deleteuser(int userId) async {
    final Response = await apiHandler.DeleteUser(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("flutter api"),
          centerTitle: true,
          backgroundColor:
              Color.fromARGB(255, 0, 0, 0), // Use Color class directly
          foregroundColor: Colors.yellowAccent,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                getData(); // Call getData() when refresh button is pressed
              },
            ),
            IconButton(
              icon: Icon(Icons.create),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateUserPage()),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditPage(
                            user: data[index],
                          )),
                );
              },
              leading: Text("${data[index].userId}"),
              title: Text("${data[index].name}"),
              subtitle: Text("${data[index].address}"),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  deleteuser(data[index].userId);
                },
              ),
              
            );
          },
        ));
  }
}
