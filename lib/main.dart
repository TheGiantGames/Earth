import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details.dart';



void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  // Variable to toggle between the themes
  bool themeBool = false;

  // Bright theme description
  ThemeData brightTheme = ThemeData(
      primarySwatch: Colors.teal,
      brightness: Brightness.light,
      textTheme: ThemeData.dark().textTheme.copyWith(
          headline1: TextStyle(
              fontSize: 36 ,fontWeight: FontWeight.bold , decoration: TextDecoration.underline ,
              color: Color(0xFF020953)
          ),
          bodyText1: TextStyle(fontSize: 24 ,fontWeight: FontWeight.bold ,
              color: Colors.black)
      ));

  // Dark theme description
  ThemeData darkTheme = ThemeData(
      primarySwatch: Colors.red,
      brightness: Brightness.dark,
      textTheme: ThemeData.dark().textTheme.copyWith(
          headline1: TextStyle(
              fontSize: 36 ,fontWeight: FontWeight.bold , decoration: TextDecoration.underline,
              decorationColor: Color(0xFFBA85FA),
              color: Color(0xFFBA85FA)
            //color:  Colors.white
          ),
          bodyText1: TextStyle(fontSize: 24 ,fontWeight: FontWeight.bold ,
              color: Colors.white)
      ));


  List<String> countries =[] ; //store countries list
  List<String> flags = []; // store countries flags
  List<dynamic> list1 = [];
  List<Map<String, dynamic>> list = []; // store searched countries

//this function will get the json response from the api and iterate through the list to get Countries name and flag
  Future<List<String>> getCountries() async{
    http.Response _response = await http.get(Uri.parse("https://restcountries.com/v3.1/all"));
    if(_response.statusCode == 200){
      List<dynamic> list = json.decode(_response.body.toString());
      for(int i = 0 ; i < list.length ; i++){
        Map<String , dynamic> _map = list[i];
        Map<String , dynamic> _name = _map['name'];
        Map<String ,dynamic> _flag = _map['flags'];

        setState(() {
          countries.add(_name['common']);
          flags.add(_flag['png']);
        });
      }
    }
    return countries;
  }


//this function help to send the correct index
  Future<List<String>> getCount() async {
    http.Response _response =
    await http.get(Uri.parse("https://restcountries.com/v3.1/all"));
    if (_response.statusCode == 200) {
      setState(() {
        list1 = json.decode(_response.body.toString());
        for (int i = 0; i < list1.length; i++) {
          list.add(list1[i]);
        }
        _foundCountries = list;
        //print(list[0]['name']['common'].toString());
        //print(countries);
      });
    }
    return countries;
  }

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundCountries = [];

  @override
  initState() {
    getCount();
    getCountries();
    super.initState();
  }


  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = list;
    } else {
      results = list
          .where((user) => user["name"]['common']
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundCountries = results;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Earth',
        theme: themeBool ?  darkTheme : brightTheme,
        home:  Scaffold(
            appBar: AppBar(
              title: Text("Countries.." , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36, color: Colors.white),),
              actions: [IconButton(onPressed: (){
                setState(() {
                  themeBool = !themeBool;
                });
              }, icon: themeBool ?  Icon(Icons.wb_sunny) : Icon(Icons.nights_stay)) ],
              // backgroundColor: Colors.teal,
            ),

            body: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15),
                      hintText: "Search",
                      suffixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: _foundCountries.isNotEmpty
                          ? ListView.separated(
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              //Here we are sending the index of tap to details screen
                              int a = 0;
                              String s = _foundCountries[index]['name']['common'];
                              if(list.isNotEmpty){
                                a = countries.indexOf(s);
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Details(index:a ,) ) );
                            },
                            child: Container(
                              // color:  Colors.teal[100],
                              child: Row(
                                children: [
                                  Container(
                                      height: 60,
                                      width: 60,
                                      margin:
                                      EdgeInsets.symmetric(horizontal: 20),
                                      child: Image.network(
                                          _foundCountries[index]['flags']['png'])),
                                  Expanded(
                                      child: Text(
                                          _foundCountries[index]['name']['common'],
                                          style: Theme.of(context).textTheme.bodyText1
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 3,
                            child: Container(
                              color: Colors.black12,
                            ),
                          );
                        },
                        itemCount: _foundCountries.length,
                        shrinkWrap: true,
                      )
                          : list.isNotEmpty ? Text("No country found with this name") : Center(child: CircularProgressIndicator())
                  ),
                ]))

        )
    );
  }



}

