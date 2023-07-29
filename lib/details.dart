import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class Details extends StatefulWidget {
  const Details({super.key , required this.index});
  final int index;

  @override
  State<Details> createState() => _DetailsState();
}

List<String> _commonName = [];
List<String> _officialName  = [];
List<String> _flags  = [];
List<double> _area  = [];
List<int> _population  = [];
List<String> _region  = [];
List<String> _carSide  = [];
List _capital  = [];
List _capitalInfo  = [];
List _timeZone  = [];
List _domain  = [];
List _phoneRoot  = [];
List _phoneSuffixes  = [];
List _languages  = [];
List _currencies  = [];
List _currencyName = [];
List _currencySymbol = [];
List _googleMap = [];




class _DetailsState extends State<Details> {


  //This function is used to store the values in correct list at correct index
  Future<List<String>> getCountries() async{
    http.Response _response = await http.get(Uri.parse("https://restcountries.com/v3.1/all"));
    if(_response.statusCode == 200){
      List<dynamic> list = json.decode(_response.body.toString());
      for(int i = 0 ; i < list.length ; i++){
        Map<String , dynamic> _map = list[i];
        Map<String , dynamic> _name = _map['name'];
        Map<String ,dynamic> _flag = _map['flags'];
        Map<String ,dynamic> _car = _map['car'];
        Map<String ,dynamic> _captitalInfo = _map['capitalInfo'];
        Map<String ,dynamic> _phoneRootId = _map['idd'];
        Map<String ,dynamic> _languagesMap ={};
        Map<String ,dynamic> _currenciesMap = {};
        Map<String ,dynamic> _google = _map['maps'] ;


        //Due to different key for each language and currency
        if(_map['languages'] == null){
          _languages.add(["No Language"]);
        }else{
          _languagesMap = _map['languages'];
          _languages.add(_languagesMap.values.toList());
        }

        if(_map['currencies'] == null){
          _currencies.add([{"currency": "No Currency" , "symbol" : "none"}]);
        }else{
          _currenciesMap = _map['currencies'];
          _currencies.add(_currenciesMap.values.toList());
        }

        //print(_currencies);

        setState(() {
          _commonName.add(_name['common']);
          _officialName.add(_name['official']);
          _flags.add(_flag['png']);
          _area.add(_map['area']);
          _population.add(_map['population']);
          _region.add(_map['region']);
          _carSide.add(_car['side']);
          _capital.add(_map['capital']);
          _capitalInfo.add(_captitalInfo['latlng']);
          _timeZone.add(_map['timezones']);
          _domain.add(_map['tld']);
          _phoneRoot.add(_phoneRootId['root']);
          _phoneSuffixes.add(_phoneRootId['suffixes']);
          _googleMap.add(_google['googleMaps']);
        });

      }


      setState(() {
        //here we are getting currencies because Keys are different in currencies field from api
        for(int i =0 ; i <_currencies.length; i++){
          List list = _currencies[i];
          //print(list);
          List name = [];
          List symbol = [];
          for(int j = 0 ; j< list.length ; j++ ) {
            Map map = list[j];
            name.add(map.values.first);
            symbol.add(map.values.last);
          }
          _currencyName.add(name);
          _currencySymbol.add(symbol);
        }
      });
    }
    return _commonName;
  }

  // To iterate through each capital
  String getCapital(){
    List list = _capital[widget.index];
    String s = "";
    for(int i = 0 ; i < list.length ; i++){
      s = s  + list[i]  + "\n";
    }
    return s;
  }
  // To iterate through each currency
  String getCurrency(){
    List list = _currencyName[widget.index];
    List symbol = _currencySymbol[widget.index];
    String s = "" ;
    for(int i = 0 ; i < list.length ; i++){
      s = s + list[i] +  "  :  "+ "("+symbol[i]+")" +  "\n";
    }
    return s;
  }
  // To iterate through each language
  String getLanguages(){
    List list = _languages[widget.index];
    String s = "";
    for(int i = 0 ; i < list.length ; i++){
      s = s  + list[i]  + "\n";
    }
    return s;
  }
  // To iterate through each Time Zone
  String getTimeZones(){
    List list = _timeZone[widget.index];
    String s = "";
    for(int i = 0 ; i < list.length ; i++){
      s = s  + list[i]  + "\n";
    }
    return s;
  }
  // To iterate through each Top level domain
  String gettld(){
    List list = _domain[widget.index];
    String s = "";
    for(int i = 0 ; i < list.length ; i++){
      s = s  + list[i]  + "\n";
    }
    return s;
  }
  // To iterate through each phone code
  String getPhoneCode(){
    List list = _phoneSuffixes[widget.index];
    String s = "";
    for(int i = 0 ; i < list.length ; i++){
      s = s  + _phoneRoot[widget.index]+ list[i]  + "\n";
    }
    return s;
  }


  @override
  void initState() {
    getCountries();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          title: Row(children: [
            Container(height: 45,
                width: 45,
                margin: EdgeInsets.only(right: 10),
                child: Image.network(_flags.isNotEmpty ? _flags[widget.index] : "https://cdn-icons-png.flaticon.com/512/608/608675.png")),
            Expanded(child: Text(_commonName.isNotEmpty ? _commonName[widget.index] : "loading..." , style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold ,),)),

          ],),),
        body:Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10),
          // color: Colors.teal[100],
          child:_googleMap.isNotEmpty ?  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.network(_flags.isNotEmpty ? _flags[widget.index] :"" ,
                      ),
                    ),
                    InkWell(child: Icon(Icons.download), onTap: (){
                      GallerySaver.saveImage(_flags[widget.index]).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Download Complete"),
                      )));
                    }, ),
                  ],
                ),
                SizedBox(height: 22,),
                Center(child: Text(_commonName[widget.index] ,
                  style: Theme.of(context).textTheme.bodyText1,)),
                SizedBox(height: 18,),
                Text("Names:" , style:Theme.of(context).textTheme.headline1,),

                Row(
                  children: [
                    Text("Official Name: " , style:  Theme.of(context).textTheme.bodyText1 ,),
                    SizedBox(width: 10,),
                    Expanded(child: Container(child: Text(_officialName[widget.index] ,  style:  Theme.of(context).textTheme.bodyText1,))),
                  ],
                ),
                SizedBox(height: 8,),

                Row(
                  children: [
                    Text("Common Name: " , style: Theme.of(context).textTheme.bodyText1,),
                    SizedBox(width: 10,),
                    Expanded(child: Container(child: Text(_commonName[widget.index] , style:  Theme.of(context).textTheme.bodyText1,))),
                  ],
                ),
                SizedBox(height: 22,),
                Text("Capitals:" ,style: Theme.of(context).textTheme.headline1,),
                Text(_capital.isNotEmpty ? getCapital() : "" , style: Theme.of(context).textTheme.bodyText1,),
                Text("Capital Location: " , style:Theme.of(context).textTheme.headline1,),
                Row(
                  children: [
                    Text("Latitude  :" , style: Theme.of(context).textTheme.bodyText1,),
                    Text("  " + _capitalInfo[widget.index][0].toString() , style:  Theme.of(context).textTheme.bodyText1,),
                  ],
                ),
                Row(
                  children: [
                    Text("Longitude  :" , style: Theme.of(context).textTheme.bodyText1,),
                    Text("  " + _capitalInfo[widget.index][1].toString() , style:  Theme.of(context).textTheme.bodyText1,),
                  ],
                ),
                SizedBox(height: 22,),
                Text("Currencies:" , style: Theme.of(context).textTheme.headline1,),
                Text(_currencyName.isNotEmpty ?  getCurrency() : "" , style: Theme.of(context).textTheme.bodyText1,),
                Text("Languages:" , style: Theme.of(context).textTheme.headline1,),
                Text(_languages.isNotEmpty ? getLanguages() : "" , style:  Theme.of(context).textTheme.bodyText1,),
                Text("Time Zones:" , style: Theme.of(context).textTheme.headline1,),
                Text(_timeZone.isNotEmpty ? getTimeZones() : "" , style: Theme.of(context).textTheme.bodyText1,),
                Text("Area Occupied:" , style: Theme.of(context).textTheme.headline1,),
                Text(_area[widget.index].toString() + "   square km " , style:  Theme.of(context).textTheme.bodyText1,),
                SizedBox(height: 22,),
                Text("Top Level Domain:" , style: Theme.of(context).textTheme.headline1,),
                Text(_domain.isNotEmpty ? gettld() : "" , style: Theme.of(context).textTheme.bodyText1,),
                Text("Population:" , style:Theme.of(context).textTheme.headline1,),
                Text(_population[widget.index].toString()  + " citizens"  , style:  Theme.of(context).textTheme.bodyText1,),
                SizedBox(height: 22,),
                Text("Phone Code:" , style: Theme.of(context).textTheme.headline1,),
                Text(getPhoneCode()   , style: Theme.of(context).textTheme.bodyText1,),
                Text("Region(continent):" , style: Theme.of(context).textTheme.headline1,),
                Text( "Continent:  " +_region[widget.index].toString()  , style: Theme.of(context).textTheme.bodyText1,),
                SizedBox(height: 22,),
                Text("Car Driving Side:" , style: Theme.of(context).textTheme.headline1,),
                Text( "Side  :  " +_carSide[widget.index].toString()  , style: Theme.of(context).textTheme.bodyText1,),
                SizedBox(height: 22,),
                Row(
                  children: [
                    Text("Google Map:   " , style:Theme.of(context).textTheme.headline1,),
                    ElevatedButton(onPressed:_launchURL, child: Text("Click Here")),
                  ],
                ),
                SizedBox(height: 24,)



              ],),
          ) : Center(child: CircularProgressIndicator()),

        )
    );


  }


  // To make the google map link work
  _launchURL() async {
    var url = Uri.parse(_googleMap[widget.index]);
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
